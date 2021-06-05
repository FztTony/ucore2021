#include "types.h"

// panic.c
void loop();
void panic(char *);

// sbi.c
void console_putchar(int);
int console_getchar();
void shutdown();

// console.c
void consoleinit(void);
void consputc(int);

// printf.c
void printf(char *, ...);

// trap.c
void trapinit();

// string.c
int memcmp(const void *, const void *, uint);
void *memmove(void *, const void *, uint);
void *memset(void *, int, uint);
char *safestrcpy(char *, const char *, int);
int strlen(const char *);
int strncmp(const char *, const char *, uint);
char *strncpy(char *, const char *, int);

// syscall.c
void syscall();

// batch.c
void batchinit();
int run_next_app();

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x) / sizeof((x)[0]))