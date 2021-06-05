#include "defs.h"
#include "proc.h"
#include "riscv.h"
#include "trap.h"
#include "memory_layout.h"

static int app_cur, app_num;
static uint64 *app_info_ptr;
extern char _app_num[];
const uint64 BASE_ADDRESS = 0x1000;
int fin = 0;

int finished() {
    ++fin;
    if (fin >= app_num)
        panic("all apps over\n");
    return 0;
}

void batchinit() {
    app_info_ptr = (uint64 *) _app_num;
    app_cur = -1;
    app_num = *app_info_ptr;
}

pagetable_t bin_loader(uint64 start, uint64 end, struct proc *p) {
    pagetable_t pg = uvmcreate();
    p->trapframe = (struct trapframe*)kalloc();
    memset(p->trapframe, 0, PGSIZE);
    if (mappages(pg, TRAPFRAME, PGSIZE,
                 (uint64)p->trapframe, PTE_R | PTE_W) < 0) {
        panic("mappages fail\n");
    }
    uint64 s = PGROUNDDOWN(start), e = PGROUNDUP(end);
    if (mappages(pg, BASE_ADDRESS, e - s, s, PTE_U | PTE_R | PTE_W | PTE_X) != 0) {
        panic("wrong loader 1\n");
    }
    p->pagetable = pg;
    p->trapframe->epc = BASE_ADDRESS;
    mappages(pg, USTACK_BOTTOM, USTACK_SIZE, (uint64) kalloc(), PTE_U | PTE_R | PTE_W | PTE_X);
    p->ustack = USTACK_BOTTOM;
    p->trapframe->sp = p->ustack + USTACK_SIZE;
    if(p->trapframe->sp > BASE_ADDRESS) {
        panic("error memory_layout");
    }
    return pg;
}

int run_all_app() {
    for (int i = 0; i < app_num; ++i) {
        app_cur++;
        app_info_ptr++;
        struct proc *p = allocproc();
        printf("load app %d\n", app_cur);
        bin_loader(app_info_ptr[0], app_info_ptr[1], p);
        p->state = RUNNABLE;
    }
    return 0;
}