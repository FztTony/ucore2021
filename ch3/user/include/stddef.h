#ifndef __STDDEF_H__
#define __STDDEF_H__

/* Represents true-or-false values */
typedef int bool;

/* Explicitly-sized versions of integer types */
typedef char int8;
typedef unsigned char uint8;
typedef short int16;
typedef unsigned short uint16;
typedef int int32;
typedef unsigned int uint32;
typedef long long int64;
typedef unsigned long long uint64;
typedef unsigned int uint;

#define ULONG_MAX (0xffffffffffffffffULL)
#define LONG_MAX (0x7fffffffffffffffLL)
#define INTMAX_MAX LONG_MAX
#define UINT_MAX (0xffffffffU)
#define INT_MAX (0x7fffffff)
#define UCHAR_MAX (0xffU)
#define CHAR_MAX (0x7f)

/* *
 * Pointers and addresses are 32 bits long.
 * We use pointer types to represent addresses,
 * uintptr_t to represent the numerical values of addresses.
 * */
#if __riscv_xlen == 64
typedef int64 intptr_t;
typedef uint64 uintptr_t;
#elif __riscv_xlen == 32
typedef int32_t intptr_t;
typedef uint32_t uintptr_t;
#endif

/* size_t is used for memory object sizes */
typedef uintptr_t size_t;
typedef intptr_t ssize_t;

typedef int pid_t;

#define NULL ((void *)0)

#define va_start(ap, last) (__builtin_va_start(ap, last))
#define va_arg(ap, type) (__builtin_va_arg(ap, type))
#define va_end(ap) (__builtin_va_end(ap))
#define va_copy(d, s) (__builtin_va_copy(d, s))
typedef __builtin_va_list va_list;

#define O_RDONLY 0x000
#define O_WRONLY 0x001
#define O_RDWR 0x002 // 可读可写
#define O_CREATE 0x200

#define DIR 0x040000
#define FILE 0x100000

#define AT_FDCWD -100

typedef struct
{
    uint64 sec;  // 自 Unix 纪元起的秒数
    uint64 usec; // 微秒数
} TimeVal;

typedef struct
{
    uint64 dev;    // 文件所在磁盘驱动器号，不考虑
    uint64 ino;    // inode 文件所在 inode 编号
    uint32 mode;   // 文件类型
    uint32 nlink;  // 硬链接数量，初始为1
    uint64 pad[7]; // 无需考虑，为了兼容性设计
} Stat;

#endif // __STDDEF_H__
