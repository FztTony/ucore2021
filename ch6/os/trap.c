#include "defs.h"
#include "trap.h"
#include "proc.h"
#include "riscv.h"
#include "memory_layout.h"

extern char trampoline[], uservec[], userret[];

void trapinit() {
    // intr_on(); // DO NOT enable interrupt unless you have handled kernel trap
    set_kerneltrap();
}

void kerneltrap() {
    if((r_sstatus() & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");
    panic("trap from kernel\n");
}

// set up to take exceptions and traps while in the kernel.
void set_usertrap(void) {
    w_stvec(((uint64) TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
}

void set_kerneltrap(void) {
    w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
}

void unknown_trap() {
    error("unknown trap: %p, stval = %p sepc = %p\n", r_scause(), r_stval(), r_sepc());
    exit(-1);
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void usertrap() {
    set_kerneltrap();
    struct trapframe *trapframe = curr_proc()->trapframe;

    if ((r_sstatus() & SSTATUS_SPP) != 0)
        panic("usertrap: not from user mode");

    uint64 cause = r_scause();
    if(cause & (1ULL << 63)) {
        cause &= ~(1ULL << 63);
        switch(cause) {
        case SupervisorTimer:
            trace("time interrupt!\n");
            set_next_timer();
            yield();
            break;
        default:
            unknown_trap();
            break;
        }
    } else {
        switch(cause) {
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
                    trapframe->epc
            );
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

void usertrapret() {
    set_usertrap();
    struct trapframe *trapframe = curr_proc()->trapframe;
    trapframe->kernel_satp = r_satp();                   // kernel page table
    trapframe->kernel_sp = curr_proc()->kstack + PGSIZE;// process's kernel stack
    trapframe->kernel_trap = (uint64) usertrap;
    trapframe->kernel_hartid = r_tp();// hartid for cpuid()

    w_sepc(trapframe->epc);
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    uint64 x = r_sstatus();
    x &= ~SSTATUS_SPP;// clear SPP to 0 for user mode
    x |= SSTATUS_SPIE;// enable interrupts in user mode
    w_sstatus(x);

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    trace("return to user at %p\n", trapframe->epc);
    uint64 fn = TRAMPOLINE + (userret - trampoline);
    ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
}
