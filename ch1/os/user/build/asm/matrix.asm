
/home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/matrix:     file format elf64-littleriscv


Disassembly of section .startup:

0000000000001000 <_start>:
.text
.globl _start
_start:
    mv a0, sp
    1000:	850a                	mv	a0,sp
    tail __start_main
    1002:	0040006f          	j	1006 <__start_main>

Disassembly of section .text:

0000000000001006 <__start_main>:
#include <unistd.h>

extern int main();

int __start_main(long* p)
{
    1006:	1141                	addi	sp,sp,-16
    1008:	e406                	sd	ra,8(sp)
    exit(main());
    100a:	0c6000ef          	jal	ra,10d0 <main>
    100e:	05c000ef          	jal	ra,106a <exit>
    return 0;
}
    1012:	60a2                	ld	ra,8(sp)
    1014:	4501                	li	a0,0
    1016:	0141                	addi	sp,sp,16
    1018:	8082                	ret

000000000000101a <open>:
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
}

static inline long __syscall3(long n, long a, long b, long c)
{
    register long a7 __asm__("a7") = n;
    101a:	03800893          	li	a7,56
    register long a0 __asm__("a0") = a;
    register long a1 __asm__("a1") = b;
    register long a2 __asm__("a2") = c;
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    101e:	00000073          	ecall

#include "syscall.h"

int open(const char *path, int flags, int mode) {
    return syscall(SYS_openat, path, flags, mode);
}
    1022:	2501                	sext.w	a0,a0
    1024:	8082                	ret

0000000000001026 <close>:
    register long a7 __asm__("a7") = n;
    1026:	03900893          	li	a7,57
    __asm_syscall("r"(a7), "0"(a0))
    102a:	00000073          	ecall

int close(int fd) {
    return syscall(SYS_close, fd);
}
    102e:	2501                	sext.w	a0,a0
    1030:	8082                	ret

0000000000001032 <read>:
    register long a7 __asm__("a7") = n;
    1032:	03f00893          	li	a7,63
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1036:	00000073          	ecall

ssize_t read(int fd, void *buf, unsigned long long len) {
    return syscall(SYS_read, fd, buf, len);
}
    103a:	8082                	ret

000000000000103c <write>:
    register long a7 __asm__("a7") = n;
    103c:	04000893          	li	a7,64
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1040:	00000073          	ecall

ssize_t write(int fd, const void *buf, unsigned long long len) {
    return syscall(SYS_write, fd, buf, len);
}
    1044:	8082                	ret

0000000000001046 <getpid>:
    register long a7 __asm__("a7") = n;
    1046:	0ac00893          	li	a7,172
    __asm_syscall("r"(a7))
    104a:	00000073          	ecall

int getpid(void) {
    return syscall(SYS_getpid);
}
    104e:	2501                	sext.w	a0,a0
    1050:	8082                	ret

0000000000001052 <sched_yield>:
    register long a7 __asm__("a7") = n;
    1052:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1056:	00000073          	ecall

int sched_yield(void) {
    return syscall(SYS_sched_yield);
}
    105a:	2501                	sext.w	a0,a0
    105c:	8082                	ret

000000000000105e <fork>:
    register long a7 __asm__("a7") = n;
    105e:	0dc00893          	li	a7,220
    __asm_syscall("r"(a7))
    1062:	00000073          	ecall

int fork(void) {
    return syscall(SYS_clone);
}
    1066:	2501                	sext.w	a0,a0
    1068:	8082                	ret

000000000000106a <exit>:
    register long a7 __asm__("a7") = n;
    106a:	05d00893          	li	a7,93
    __asm_syscall("r"(a7), "0"(a0))
    106e:	00000073          	ecall

void exit(int code) {
    syscall(SYS_exit, code);
}
    1072:	8082                	ret

0000000000001074 <wait>:
    register long a7 __asm__("a7") = n;
    1074:	10400893          	li	a7,260
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
    1078:	00000073          	ecall

int wait(int pid, int* code) {
    return syscall(SYS_wait4, pid, code);
}
    107c:	2501                	sext.w	a0,a0
    107e:	8082                	ret

0000000000001080 <exec>:
    register long a7 __asm__("a7") = n;
    1080:	0dd00893          	li	a7,221
    __asm_syscall("r"(a7), "0"(a0))
    1084:	00000073          	ecall

int exec(char* name) {
    return syscall(SYS_execve, name);
}
    1088:	2501                	sext.w	a0,a0
    108a:	8082                	ret

000000000000108c <get_time>:
    register long a7 __asm__("a7") = n;
    108c:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1090:	00000073          	ecall

uint64 get_time() {
    return syscall(SYS_times);
}
    1094:	8082                	ret

0000000000001096 <sleep>:

int sleep(unsigned long long time) {
    1096:	872a                	mv	a4,a0
    register long a7 __asm__("a7") = n;
    1098:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    109c:	00000073          	ecall
    10a0:	87aa                	mv	a5,a0
    10a2:	00000073          	ecall
    unsigned long long s = get_time();
    while(get_time() < s + time) {
    10a6:	97ba                	add	a5,a5,a4
    10a8:	00f57c63          	bgeu	a0,a5,10c0 <sleep+0x2a>
    register long a7 __asm__("a7") = n;
    10ac:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    10b0:	00000073          	ecall
    register long a7 __asm__("a7") = n;
    10b4:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    10b8:	00000073          	ecall
    10bc:	fef568e3          	bltu	a0,a5,10ac <sleep+0x16>
        sched_yield();
    }
    return 0;
}
    10c0:	4501                	li	a0,0
    10c2:	8082                	ret

00000000000010c4 <pipe>:
    register long a7 __asm__("a7") = n;
    10c4:	03b00893          	li	a7,59
    __asm_syscall("r"(a7), "0"(a0))
    10c8:	00000073          	ecall

int pipe(void* p) {
    return syscall(SYS_pipe2, p);
    10cc:	2501                	sext.w	a0,a0
    10ce:	8082                	ret

Disassembly of section .text.startup:

00000000000010d0 <main>:
            }
        }
    }

    return 0;
}
    10d0:	4501                	li	a0,0
    10d2:	8082                	ret
