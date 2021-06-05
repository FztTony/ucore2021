#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define PGSIZE (4096)
#define MAXVA (1L << (9 + 9 + 9 + 12 - 1))
#define USER_TOP (MAXVA)
#define TRAMPOLINE (USER_TOP - PGSIZE)
#define TRAPFRAME (TRAMPOLINE - PGSIZE)

void fork_test(void(*fn)(int)) {
    const int NUM = 200;
    for (int i = 0; i < NUM; ++i) {
        int pid = fork();
        if (pid == 0) {
            fn(i);
            exit(0);
        }
    }
    int xstate = 0;
    for (int i = 0; i < NUM; ++i) {
        assert(wait(&xstate) > 0);
        assert(xstate == 0);
    }
    assert(wait(&xstate) < 0);
}

inline uint64 get_pc() {
    uint64 pc;
    asm volatile("auipc %0, 0": "=r"(pc));
    return pc;
}

uint64 randl() {
    return (uint64)(rand()) << 32 | rand();
}

int xorshift32(int x) {
    x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
    return x;
}

int hash(int x) {
    return xorshift32(x);
}

inline long syscall(long n, long a, long b, long c, long d, long e, long f)
{
    register long a7 __asm__("a7") = n;
    register long a0 __asm__("a0") = a;
    register long a1 __asm__("a1") = b;
    register long a2 __asm__("a2") = c;
    register long a3 __asm__("a3") = d;
    register long a4 __asm__("a4") = e;
    register long a5 __asm__("a5") = f;
    asm volatile("ecall" : "=r"(a0): "r"(a7), "0"(a0), "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5));
    return a0;
}