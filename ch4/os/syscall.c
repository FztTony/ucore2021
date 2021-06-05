#include "defs.h"
#include "syscall_ids.h"
#include "trap.h"
#include "proc.h"
#include "riscv.h"

#define min(a, b) a < b ? a : b;

struct TimeVal {
	uint64 sec;	// 自 Unix 纪元起的秒数
	uint64 usec;	// 微秒，也就是除了秒的那点零头
};

uint64 sys_write(int fd, char *addr, uint len) {
    if (fd != 1)
        return -1;
    struct proc *p = curr_proc();
    char str[200];
    int size = copyinstr(p->pagetable, str, (uint64) addr, MIN(len, 200));
    debug("size = %d\n", size);
    for(int i = 0; i < size; ++i) {
        console_putchar(str[i]);
    }
    return size;
}

uint64 sys_exit(int code) {
    exit(code);
    return 0;
}

uint64 sys_sched_yield() {
    yield();
    return 0;
}

uint64 sys_gettimeofday(struct TimeVal* ts, int tz) {
    // debug("sys_gettimeofday start\n");
    struct proc *p = curr_proc();
    struct TimeVal ts1;
    uint64 cycle = get_cycle();
    ts1.usec = (cycle % 12500000) *2 / 25;
    ts1.sec = cycle / 12500000;
    copyout(p->pagetable, (uint64)ts, (char *)(&ts1), sizeof(struct TimeVal));
    // debug("%d %d %d\n",cycle, ts->sec, ts->usec);
    // debug("sys_gettimeofday end\n");
    return 0;
}

uint64 sys_setpriority(long long prio) {
    if (!(2 <= prio && prio <= INT_MAX))
        return -1;
    curr_proc()->prio = prio;
    return prio;
}

uint64 sys_mmap(uint64 start, uint64 len, int port) {
    if (len == 0)
        return 0;
    if (len > 0x40000000)
        return -1;
    if (((port & ~0x7) != 0) || ((port & 0x7) == 0))
        return -1;
    if (start % PGSIZE != 0)
        return -1;
    uint64 nums = (len + PGSIZE - 1) / PGSIZE, va = start;
    struct proc *p = curr_proc();
    // if [addr, addr + len) 存在被映射, return -1;
    // 申请 (len + 4095) / 4096页内存，如果内存不够，return -1
    // 进行虚存映射
    for (uint64 i = 0; i < nums; ++i) {
        if (useraddr(p->pagetable, va) != 0)
            return -1;
        if (mappages(p->pagetable, va, PGSIZE, (uint64)kalloc(), PTE_U | (port << 1)) < 0)
            return -1;
        va += PGSIZE;
    }
    return nums * PGSIZE;
}

uint64 sys_munmap(uint64 start, uint64 len) {
    if (len == 0)
        return 0;
    if (len > 0x40000000)
        return -1;
    if (start % PGSIZE != 0)
        return -1;
    uint64 nums = (len + PGSIZE - 1) / PGSIZE, va = start;
    struct proc *p = curr_proc();
    // if [addr, addr + len) 存在被映射, return -1;
    // 申请 (len + 4095) / 4096页内存，如果内存不够，return -1
    // 进行虚存映射
    for (uint64 i = 0; i < nums; ++i) {
        if (useraddr(p->pagetable, va) == 0)
            return -1;
        uvmunmap(p->pagetable, va, 1, 1);
        va += PGSIZE;
    }
    return nums * PGSIZE;
}

void syscall() {
    struct trapframe *trapframe = curr_proc()->trapframe;
    int id = trapframe->a7, ret;
    uint64 args[6] = {trapframe->a0, trapframe->a1, trapframe->a2, trapframe->a3, trapframe->a4, trapframe->a5};
    debug("syscall %d args:%p %p %p %p %p %p\n", id, args[0], args[1], args[2], args[3], args[4], args[5]);
    switch (id) {
        case SYS_write:
            ret = sys_write(args[0], (char *) args[1], args[2]);
            debug("\n");
            break;
        case SYS_exit:
            ret = sys_exit(args[0]);
            break;
        case SYS_sched_yield:
            ret = sys_sched_yield();
            break;
        case SYS_gettimeofday:
            ret = sys_gettimeofday((struct TimeVal *)args[0], args[1]);
            break;
        case SYS_setpriority:
            ret = sys_setpriority(args[0]);
            break;
        case SYS_munmap:
            ret = sys_munmap(args[0], args[1]);
            break;
        case SYS_mmap:
            ret = sys_mmap(args[0], args[1], args[2]);
            break;
        default:
            ret = -1;
            debug("unknown syscall %d\n", id);
    }
    trapframe->a0 = ret;
    debug("syscall ret %d\n", ret);
}
