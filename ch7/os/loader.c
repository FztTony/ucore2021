#include "defs.h"
#include "proc.h"
#include "riscv.h"
#include "trap.h"
#include "memory_layout.h"

static int app_cur, app_num;
static uint64 *app_info_ptr;
extern char _app_num[], _app_names[];
int fin = 0;
char names[30][100];
// #define BASE_ADDRESS (4096)
// #define USTACK_BOTTOM (0)

const uint64 BASE_ADDRESS = 0x1000;
const uint64 USTACK_BOTTOM = 0x0;

void batchinit() {
    char* s;
    app_info_ptr = (uint64 *) _app_num;
    app_cur = -1;
    app_num = *app_info_ptr;
    app_info_ptr++;

    s = _app_names;
    for(int i = 0; i < app_num; ++i) {
        int len = strlen(s);
        strncpy(names[i], (const char*)s, len);
        s += len + 1;
        printf("user app: %s\n", names[i]);
    }
}

int get_id_by_name(char* name) {
    for(int i = 0; i < app_num; ++i) {
        if(strncmp(name, names[i], 100) == 0)
            return i;
    }
    warn("not find such app\n");
    return -1;
}

void alloc_ustack(struct proc *p) {
    void* page = kalloc();
    if(page == 0) {
        panic("can't alloc user stack");
    }
    memset(page, 0, PGSIZE);
    if (mappages(p->pagetable, USTACK_BOTTOM, USTACK_SIZE, (uint64) page, PTE_U | PTE_R | PTE_W | PTE_X) != 0) {
        panic("");
    }
    p->ustack = USTACK_BOTTOM;
    p->trapframe->sp = p->ustack + USTACK_SIZE;
    if(p->trapframe->sp > BASE_ADDRESS) {
        panic("error memory_layout");
    }
}

void bin_loader(uint64 start, uint64 end, struct proc *p) {
    info("load range = [%p, %p)\n", start, end);
    uint64 s = PGROUNDDOWN(start), e = PGROUNDUP(end), length = e - s;
    for(uint64 va = BASE_ADDRESS, pa = s; pa < e; va += PGSIZE, pa += PGSIZE) {
        void* page = kalloc();
        if(page == 0) {
            panic("");
        }
        memmove(page, (const void*)pa, PGSIZE);
        if (mappages(p->pagetable, va, PGSIZE, (uint64)page, PTE_U | PTE_R | PTE_W | PTE_X) != 0)
            panic("");
    }

    p->trapframe->epc = BASE_ADDRESS;
    alloc_ustack(p);
    p->sz = USTACK_SIZE + length;
}

void loader(int id, void* p) {
    info("loader %s\n", names[id]);
    bin_loader(app_info_ptr[id], app_info_ptr[id+1], p);
}

int run_all_app() {
    struct proc *p = allocproc();
    p->parent = 0;
    int id = get_id_by_name("ch7_usertest");
    if(id < 0)
        panic("no user shell");
    loader(id, p);
    p->state = RUNNABLE;
    return 0;
}