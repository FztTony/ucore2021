#include "types.h"

struct buf;
struct context;
struct file;
struct inode;
struct pipe;
struct proc;
// struct stat;
struct superblock;

// panic.c
void loop();
void panic(char *);

// sbi.c
void console_putchar(int);
int console_getchar();
void set_timer(uint64);
void shutdown();

// console.c
void consoleinit(void);
void consputc(int);

// logger.c
void printf(const char *, ...);
#include "logger.h"

// trap.c
void trapinit();
void usertrapret();
void set_usertrap(void);
void set_kerneltrap(void);

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
int get_id_by_name(char *name);
void loader(int, void *);

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
int fdalloc(struct file *);
int cpuid();
struct proc* get_proc_by_pid(int);

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
uint64 walkaddr(pagetable_t, uint64);
uint64 useraddr(pagetable_t, uint64);
void debugwalk(pagetable_t, int);
int copyin(pagetable_t, char*, uint64, uint64);
int copyout(pagetable_t, uint64, char*, uint64);
int copyinstr(pagetable_t, char*, uint64, uint64);
int either_copyout(int user_dst, uint64 dst, char* src, uint64 len);
int either_copyin(int user_src, uint64 src, char* dst, uint64 len);

// timer.c
uint64 get_cycle();
void timerinit();
void set_next_timer();
uint64 get_time_ms();

// pipe.c
int pipealloc(struct file *, struct file *);
void pipeclose(struct pipe *, int);
int piperead(struct pipe *, uint64, int);
int pipewrite(struct pipe *, uint64, int);

// file.c
void fileclose(struct file *);
struct file *filealloc();
int fileopen(char*, uint64);
uint64 filewrite(struct file*, uint64, uint64);
uint64 fileread(struct file*, uint64, uint64);

// plic.c
void plicinit(void);
int plic_claim(void);
void plic_complete(int);

// virtio_disk.c
void virtio_disk_init(void);
void virtio_disk_rw(struct buf *, int);
void virtio_disk_intr(void);

// fs.c
void fsinit();
int dirlink(struct inode *, char *, uint);
int dirunlink(struct inode *, char *);
struct inode *dirlookup(struct inode *, char *, uint *);
struct inode *ialloc(uint, short);
struct inode *idup(struct inode *);
void iinit();
void ivalid(struct inode *);
void iput(struct inode *);
void iunlock(struct inode *);
void iunlockput(struct inode *);
void iupdate(struct inode *);
struct inode *namei(char *);
struct inode *root_dir();
int readi(struct inode *, int, uint64, uint, uint);
int writei(struct inode *, int, uint64, uint, uint);
void itrunc(struct inode *);

// bio.c
void binit(void);
struct buf *bread(uint, uint);
void brelse(struct buf *);
void bwrite(struct buf *);
void bpin(struct buf *);
void bunpin(struct buf *);

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x) / sizeof((x)[0]))

#define MIN(a, b) (a < b ? a : b)
#define MAX(a, b) (a > b ? a : b)