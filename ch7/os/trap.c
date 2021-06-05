#include "defs.h"
#include "trap.h"
#include "proc.h"
#include "riscv.h"
#include "memory_layout.h"

extern char trampoline[], uservec[], userret[];
void kernelvec();

// set up to take exceptions and traps while in the kernel.
void set_usertrap(void) {
    w_stvec(((uint64) TRAMPOLINE + (uservec - trampoline)) & ~0x3);     // DIRECT
}

void set_kerneltrap(void) {
    w_stvec((uint64) kernelvec & ~0x3);     // DIRECT
}

void trapinit() {
    set_kerneltrap();
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
}

void unknown_trap() {
    error("unknown trap: %p, stval = %p sepc = %p\n", r_scause(), r_stval(), r_sepc());
    exit(-1);
}

void devintr(uint64 cause) {
    int irq;
    switch (cause) {
        case SupervisorTimer:
            set_next_timer();
            // if form user, allow yield
            if((r_sstatus() & SSTATUS_SPP) == 0) {
                yield();
            }
            break;
        case SupervisorExternal:
            irq = plic_claim();
            if (irq == UART0_IRQ) {
                // do nothing
            } else if (irq == VIRTIO0_IRQ) {
                virtio_disk_intr();
            } else if (irq) {
                info("unexpected interrupt irq=%d\n", irq);
            }
            if (irq)
                plic_complete(irq);
            break;
        default:
            unknown_trap();
            break;
    }
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void usertrap() {
    set_kerneltrap();
    struct trapframe *trapframe = curr_proc()->trapframe;
    trace("usertrap from %p\n", trapframe->epc);
    if ((r_sstatus() & SSTATUS_SPP) != 0)
        panic("usertrap: not from user mode");

    uint64 cause = r_scause();
    if (cause & (1ULL << 63)) {
        devintr(cause & 0xff);
    } else {
        switch (cause) {
            case UserEnvCall:
                trapframe->epc += 4;
                syscall();
                break;
            case StoreFault:
            case StorePageFault:
            case InstructionFault:
            case InstructionPageFault:
            case LoadFault:
            case LoadPageFault:
                error(
                        "%d in application, bad addr = %p, bad instruction = %p, core dumped.\n",
                        cause,
                        r_stval(),
                        trapframe->epc);
                exit(-2);
                break;
            case IllegalInstruction:
                error("IllegalInstruction in application, epc = %p, core dumped.\n", trapframe->epc);
                exit(-3);
                break;
            default:
                unknown_trap();
                break;
        }
    }
    usertrapret();
}

extern int PID;

void usertrapret() {
    struct trapframe *trapframe;
    set_usertrap();
    trapframe = curr_proc()->trapframe;
    trapframe->kernel_satp = r_satp();                      // kernel page table
    trapframe->kernel_sp = curr_proc()->kstack + PGSIZE;    // process's kernel stack
    trapframe->kernel_trap = (uint64) usertrap;
    trapframe->kernel_hartid = r_tp();                      // hartid for cpuid()

    w_sepc(trapframe->epc);
    // set S Previous Privilege mode to User.
    uint64 x = r_sstatus();
    x &= ~SSTATUS_SPP;// clear SPP to 0 for user mode
    x |= SSTATUS_SPIE;// enable interrupts in user mode
    w_sstatus(x);

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    trace("return to user at %p\n", trapframe->epc);
    uint64 fn = TRAMPOLINE + (userret - trampoline);
    ((void (*)(uint64, uint64)) fn)(TRAPFRAME, satp);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.

void kerneltrap() {
    uint64 sepc = r_sepc();
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();

    if ((sstatus & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");

    if (scause & (1ULL << 63)) {
        devintr(scause & 0xff);
    } else {
        error("invalid trap from kernel: %p, stval = %p sepc = %p\n", scause, r_stval(), sepc);
        exit(-1);
    }
    // the yield() may have caused some traps to occur,
    // so restore trap registers for use by kernelvec.S's sepc instruction.
    w_sepc(sepc);
    w_sstatus(sstatus);
}
