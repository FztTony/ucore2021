#include "defs.h"
#include "proc.h"
#include "trap.h"
#include "riscv.h"
#include "file.h"
#include "memory_layout.h"

struct proc pool[NPROC];

__attribute__ ((aligned (16))) char kstack[NPROC][KSTACK_SIZE];
extern char trampoline[];

extern char boot_stack_top[];
struct proc* current_proc = 0;
struct proc idle;
int curr_pid = 0;

struct proc* curr_proc() {
    if(current_proc == 0)
        return &idle;
    return current_proc;
}

void
procinit(void)
{
    struct proc *p;
    for(p = pool; p < &pool[NPROC]; p++) {
        p->state = UNUSED;
        p->kstack = (uint64) kstack[p - pool];
        // must after kinit()
        p->trapframe = kalloc();
    }
    idle.kstack = (uint64)boot_stack_top;
    idle.pid = 0;
}

int allocpid() {
    static int PID = 1;
    return PID++;
}

pagetable_t
proc_pagetable(struct proc *p)
{
    pagetable_t pagetable;

    // An empty page table.
    pagetable = uvmcreate();
    if(pagetable == 0)
        panic("");

    if(mappages(pagetable, TRAMPOLINE, PGSIZE,
                (uint64)trampoline, PTE_R | PTE_X) < 0){
        uvmfree(pagetable, 0);
        return 0;
    }

    memset(p->trapframe, 0, sizeof(struct trapframe));

    // map the trapframe just below TRAMPOLINE, for trampoline.S.
    if(mappages(pagetable, TRAPFRAME, PGSIZE,
                (uint64)(p->trapframe), PTE_R | PTE_W) < 0){;
        panic("");
    }

    return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    uvmfree(pagetable, sz);
}

static void
freeproc(struct proc *p)
{
    if(p->pagetable)
        proc_freepagetable(p->pagetable, p->sz);
    p->pagetable = 0;
    p->state = UNUSED;
    for(int i = 0; i < FD_MAX; ++i) {
        if(p->files[i] != 0) {
            fileclose(p->files[i]);
            p->files[i] = 0;
        }
    }
}

struct proc* allocproc(void)
{
    struct proc *p;
    for(p = pool; p < &pool[NPROC]; p++) {
        if(p->state == UNUSED) {
            goto found;
        }
    }
    return 0;

found:
    p->pid = allocpid();
    p->state = USED;
    p->sz = 0;
    p->exit_code = -1;
    p->parent = 0;
    p->ustack = 0;
    p->pagetable = proc_pagetable(p);
    if(p->pagetable == 0){
        panic("");
    }
    memset(&p->context, 0, sizeof(p->context));
    memset((void*)p->kstack, 0, KSTACK_SIZE);
    p->context.ra = (uint64)usertrapret;
    p->context.sp = p->kstack + KSTACK_SIZE;

    memset(p->mails.data, 0, sizeof(p->mails.data));
    memset(p->mails.size, 0, sizeof(p->mails.size));
    p->mails.nread = 0;
    p->mails.nwrite = 0;
    return p;
}


void
scheduler(void)
{
    struct proc *p;
    for(;;){
        int all_done = 1;
        for(p = pool; p < &pool[NPROC]; p++) {
            if(p->state == RUNNABLE) {
                all_done = 0;
                p->state = RUNNING;
                current_proc = p;
                curr_pid = p->pid;
                trace("switch to next proc %d\n", p->pid);
                swtch(&idle.context, &p->context);
            }
        }
        if(all_done)
            panic("all apps over\n");
    }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
    struct proc *p = curr_proc();
    if(p->state == RUNNING)
        panic("sched running");
    current_proc = &idle;
    swtch(&p->context, &idle.context);
}

// Give up the CPU for one scheduling round.
void yield(void)
{
    struct proc *p = curr_proc();
    p->state = RUNNABLE;
    sched();
}

int spawn(char *name) {
    int pid;
    struct proc *np;
    struct proc *p = curr_proc();
    // Allocate process.
    if((np = allocproc()) == 0){
        panic("allocproc\n");
    }
    // Copy user memory from parent to child.
    // // deleted
    // if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    //     panic("uvmcopy\n");
    // }
    // np->sz = p->sz;

    // // copy saved user registers.
    // *(np->trapframe) = *(p->trapframe);

    // // Cause fork to return 0 in the child.
    // np->trapframe->a0 = 0;
    pid = np->pid;
    np->parent = p;
    np->state = RUNNABLE;
    int id = get_id_by_name(name);
    if(id < 0)
        return -1;
    // // deleted
    // proc_freepagetable(np->pagetable, np->sz);
    // np->sz = 0;
    np->pagetable = proc_pagetable(np);
    if(np->pagetable == 0){
        panic("");
    }
    loader(id, np);
    return pid;
}

int
fork(void)
{
    int pid;
    struct proc *np;
    struct proc *p = curr_proc();
    // Allocate process.
    if((np = allocproc()) == 0){
        panic("allocproc\n");
    }
    // Copy user memory from parent to child.
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
        panic("uvmcopy\n");
    }
    np->sz = p->sz;

    // copy saved user registers.
    *(np->trapframe) = *(p->trapframe);

    for(int i = 0; i < FD_MAX; ++i)
        if(p->files[i] != 0 && p->files[i]->type != FD_NONE) {
            p->files[i]->ref++;
            np->files[i] = p->files[i];
        }

    // Cause fork to return 0 in the child.
    np->trapframe->a0 = 0;
    pid = np->pid;
    np->parent = p;
    np->state = RUNNABLE;
    return pid;
}

int exec(char* name) {
    int id = get_id_by_name(name);
    if(id < 0)
        return -1;
    struct proc *p = curr_proc();
    proc_freepagetable(p->pagetable, p->sz);
    p->sz = 0;
    p->pagetable = proc_pagetable(p);
    if(p->pagetable == 0){
        panic("");
    }
    loader(id, p);
    return 0;
}

int
wait(int pid, int* code)
{
    struct proc *np;
    int havekids;
    struct proc *p = curr_proc();

    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(np = pool; np < &pool[NPROC]; np++){
            if(np->state != UNUSED && np->parent == p && (pid <= 0 || np->pid == pid)){
                havekids = 1;
                // info("find child %d state = %d\n", np->pid, np->state);
                if(np->state == ZOMBIE){
                    // Found one.
                    np->state = UNUSED;
                    pid = np->pid;
                    *code = np->exit_code;
                    return pid;
                }
            }
        }
        if(!havekids){
            return -1;
        }
        p->state = RUNNABLE;
        sched();
    }
}

void exit(int code) {
    struct proc *p = curr_proc();
    p->exit_code = code;
    info("proc %d exit with %d\n", p->pid, code);
    freeproc(p);
    if(p->parent != 0) {
        trace("wait for parent to clean\n");
        p->state = ZOMBIE;
    }
    sched();
}

int fdalloc(struct file* f) {
    struct proc* p = curr_proc();
    // fd = 0,1,2 is reserved for stdio/stdout
    for(int i = 3; i < FD_MAX; ++i) {
        if(p->files[i] == 0) {
            p->files[i] = f;
            return i;
        }
    }
    return -1;
}

int cpuid() {
    return 0;
}

struct proc* get_proc_by_pid(int pid) {
    struct proc *p;
    for(p = pool; p < &pool[NPROC]; p++) {
        if (p->pid == pid) {
            return p;
        }
    }
    return 0;
}