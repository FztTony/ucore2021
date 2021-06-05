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

int getint() {
    char buf[10 + 1];
    int i = -1;
    do {
        buf[++i] = getchar();
        putchar(buf[i]);
    }
    while(i < 10 && buf[i] >= '0' && buf[i] <= '9');
    buf[i] = 0;
    return atoi(buf);
}

int main() {
    puts("Input a seed please:");
    int seed = getint();
    srand(seed);
    printf("seed = %d\n", seed);
    for(int i = 0; i < N; ++i) {
        syscall(rand_syscall_id(), rand_arg(), rand_arg(), rand_arg(), rand_arg(), rand_arg(), rand_arg());
    }
    puts("This is impossible!");
    return 0;
}