#include "defs.h"
#include "syscall_ids.h"
#include "trap.h"
#include "proc.h"

#define min(a, b) a < b ? a : b;

struct TimeVal {
	uint64 sec;	// 自 Unix 纪元起的秒数
	uint64 usec;	// 微秒，也就是除了秒的那点零头
};

uint64 sys_write(int fd, char *str, uint len) {
    if (fd != 1)
        return -1;
    struct proc* p = curr_proc();
    char *base_address = (char *)(p->trapframe->epc);
    char *user_stack = (char *)p->ustack;
    if (!(
        (base_address <= str && str + len <= base_address + 0x20000) ||
        (user_stack <= str && str + len <= user_stack + 4096)
    ))
        return -1;
    int size = min(strlen(str), len);
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
    // printf("sys_gettimeofday start\n");
    uint64 cycle = get_cycle();
    ts->usec = (cycle % 12500000) *2 / 25;
    ts->sec = cycle / 12500000;
    // printf("%d %d %d\n",cycle, ts->sec, ts->usec);
    // printf("sys_gettimeofday end\n");
    return 0;
}

uint64 sys_setpriority(long long prio) {
    if (!(2 <= prio && prio <= INT_MAX))
        return -1;
    curr_proc()->prio = prio;
    return prio;
}

void syscall() {
    struct trapframe *trapframe = curr_proc()->trapframe;
    int id = trapframe->a7, ret;
    // printf("syscall %d\n", id);
    uint64 args[7] = {trapframe->a0, trapframe->a1, trapframe->a2, trapframe->a3, trapframe->a4, trapframe->a5, trapframe->a6};
    switch (id) {
        case SYS_write:
            ret = sys_write(args[0], (char *) args[1], args[2]);
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
        default:
            ret = -1;
            printf("unknown syscall %d\n", id);
    }
    trapframe->a0 = ret;
    // printf("syscall ret %d\n", ret);
}
