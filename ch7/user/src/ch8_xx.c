#include "ch8.h"
#include "syscall_ids.h"

int syscall_id[] = {
    SYS_write,
    SYS_read,
    SYS_openat,
    SYS_close,
    SYS_exit,
    SYS_sched_yield,
    SYS_getpid,
    SYS_clone,
    SYS_execve,
    SYS_wait4,
    SYS_times,
    SYS_pipe2,
};

#define NELEM(x) (sizeof(x) / sizeof((x)[0]))

const int N = 10000;

int rand_syscall_id() {
    uint32 n = rand() % 10;
    if(n == 0) {
        return 0;
    }
    if (n < 3) {
        return rand();
    }
    return syscall_id[rand() % NELEM(syscall_id)];
}

uint64 rand_arg() {
    uint32 n = rand() % 10;
    if(n < 4) {
        return 0;
    }
    return randl();
}

int main() {
    srand(77777);
    int i;
    for(i = 0; i < N; ++i) {
        syscall(rand_syscall_id(), rand_arg(), rand_arg(), rand_arg(), rand_arg(), rand_arg(), rand_arg());
    }
    puts("nice!");
    return 0;
}