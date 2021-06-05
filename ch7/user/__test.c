#include "stdio.h"
#include "stdlib.h"

typedef char int8;
typedef unsigned char uint8;
typedef short int16;
typedef unsigned short uint16;
typedef int int32;
typedef unsigned int uint32;
typedef long long int64;
typedef unsigned long long uint64;
typedef unsigned int uint;

const int N = 10000;

int rand_syscall_id() {
    uint32 n = rand() % 10;
    if (n < 3) {
        return rand();
    }
    return rand() % 294;
}

uint64 randl() {
    return (uint64)(rand()) << 32 | rand();
}

uint64 rand_arg() {
    uint32 n = rand() % 10;
    if(n < 4) {
        return 0;
    }
    return randl();
}

static long syscall(long n, long a1, long a2, long a3, long a4, long a5, long a6)
{
	unsigned long ret;
	register long r10 __asm__("r10") = a4;
	register long r8 __asm__("r8") = a5;
	register long r9 __asm__("r9") = a6;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "aq"(n), "D"(a1), "S"(a2),
						  "d"(a3), "r"(r10), "r"(r8), "r"(r9) : "rcx", "r11", "memory");
	return ret;
}

int main() {
    puts("hello world\n");
    srand(666);
    int i;
    for(i = 0; i < N; ++i) {
        printf("case %d\n", i);
        syscall(rand_syscall_id(), rand_arg(), rand_arg(), rand_arg(), rand_arg(), rand_arg(), rand_arg());
    }
    puts("6666!");
    return 0;
}