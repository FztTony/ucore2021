#include "types.h"

// panic.c
void loop();

// sbi.c
void console_putchar(int);
int console_getchar();
void shutdown();

// console.c
void consputc(int);

// printf.c
void printf(char *, ...);
void error(char *,...);
void warn(char *,...);
void info(char *,...);
void debug(char *,...);
void trace(char *,...);
void printfinit(void);
void panic(char*);

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x) / sizeof((x)[0]))