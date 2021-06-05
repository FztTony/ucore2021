#include "types.h"
struct context;
struct proc;

// panic.c
void loop();
void panic(char *);

// sbi.c
void console_putchar(int);
int console_getchar();
void shutdown();
void set_timer(uint64 stime);

// console.c
void consputc(int);

// printf.c
void printf(char *, ...);
#include "logger.h"

// trap.c
void trapinit();
void usertrapret();
void set_usertrap();
void set_kerneltrap();

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

// swtch.S
void swtch(struct context *, struct context *);

// loader.c
void batchinit();
int run_all_app();
int get_id_by_name(char* name);
void loader(int, void*);

// proc.c
struct proc *curr_proc();
void exit(int);
void procinit(void);
void scheduler(void) __attribute__((noreturn));
void sched(void);
void yield(void);
int fork(void);
int exec(char*);
int wait(int, int*);
int spawn(char*);
struct proc *allocproc();

// kalloc.c
void *kalloc(void);
void kfree(void *);
void kinit(void);

// vm.c
void kvminit(void);
void kvmmap(pagetable_t, uint64, uint64, uint64, int);
int mappages(pagetable_t, uint64, uint64, uint64, int);
pagetable_t uvmcreate(void);
void uvminit(pagetable_t, uchar *, uint);
uint64 uvmalloc(pagetable_t, uint64, uint64);
uint64 uvmdealloc(pagetable_t, uint64, uint64);
int uvmcopy(pagetable_t, pagetable_t, uint64);
void uvmfree(pagetable_t, uint64);
void uvmunmap(pagetable_t, uint64, uint64, int);
void uvmclear(pagetable_t, uint64);
uint64 walkaddr(pagetable_t, uint64);
uint64 useraddr(pagetable_t, uint64);
int copyout(pagetable_t, uint64, char *, uint64);
int copyin(pagetable_t, char *, uint64, uint64);
int copyinstr(pagetable_t, char *, uint64, uint64);

// timer.c
uint64 get_cycle();
void timerinit();
void set_next_timer();
uint64 get_time_ms();

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x) / sizeof((x)[0]))

#define MIN(a, b) (a < b ? a : b)
#define MAX(a, b) (a > b ? a : b)