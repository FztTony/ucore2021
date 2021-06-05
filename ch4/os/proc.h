#define NPROC (16)
#define KSTACK_SIZE (4096)
#define USTACK_SIZE (4096)
#define TRAPFRAME_SIZE (4096)

struct context {
    uint64 ra;
    uint64 sp;

    // callee-saved
    uint64 s0;
    uint64 s1;
    uint64 s2;
    uint64 s3;
    uint64 s4;
    uint64 s5;
    uint64 s6;
    uint64 s7;
    uint64 s8;
    uint64 s9;
    uint64 s10;
    uint64 s11;
};

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
    // p->lock must be held when using these:
    enum procstate state;        // Process state
    int killed;                  // If non-zero, have been killed
    int pid;                     // Process ID
    pagetable_t pagetable;       // User page table
    // these are private to the process, so p->lock need not be held.
    uint64 ustack;
    uint64 kstack;               // Virtual address of kernel stack
    struct trapframe *trapframe; // data page for trampoline.S
    struct context context;      // swtch() here to run process
    int prio;
    uint64 stride;
};