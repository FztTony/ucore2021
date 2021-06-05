#include "defs.h"
#include "syscall_ids.h"
#include "trap.h"
#include "proc.h"
#include "riscv.h"

struct TimeVal {
	uint64 sec;	// 自 Unix 纪元起的秒数
	uint64 usec;	// 微秒，也就是除了秒的那点零头
};

#define min(a, b) a < b ? a : b;

uint64 console_write(uint64 va, uint64 len) {
    struct proc *p = curr_proc();
    char str[200];
    int size = copyinstr(p->pagetable, str, va, MIN(len, 200));
    for(int i = 0; i < size; ++i) {
        console_putchar(str[i]);
    }
    return size;
}

uint64 sys_gettimeofday(struct TimeVal* ts, int tz) {
    // debug("sys_gettimeofday start\n");
    struct proc *p = curr_proc();
    struct TimeVal ts1;
    uint64 cycle = get_cycle();
    ts1.usec = (cycle % 12500000) *2 / 25;
    ts1.sec = cycle / 12500000;
    copyout(p->pagetable, (uint64)ts, (char *)(&ts1), sizeof(struct TimeVal));
    // debug("%d %d %d\n",cycle, ts->sec, ts->usec);
    // debug("sys_gettimeofday end\n");
    return 0;
}

uint64 sys_setpriority(long long prio) {
    if (!(2 <= prio && prio <= 0x7FFFFFFF))
        return -1;
    return prio;
}

uint64 sys_mmap(uint64 start, uint64 len, int port) {
    if (len == 0)
        return 0;
    if (len > 0x40000000)
        return -1;
    if (((port & ~0x7) != 0) || ((port & 0x7) == 0))
        return -1;
    if (start % PGSIZE != 0)
        return -1;
    uint64 nums = (len + PGSIZE - 1) / PGSIZE, va = start;
    struct proc *p = curr_proc();
    for (uint64 i = 0; i < nums; ++i) {
        if (useraddr(p->pagetable, va) != 0)
            return -1;
        if (mappages(p->pagetable, va, PGSIZE, (uint64)kalloc(), PTE_U | (port << 1)) < 0)
            return -1;
        va += PGSIZE;
    }
    return nums * PGSIZE;
}

uint64 sys_munmap(uint64 start, uint64 len) {
    if (len == 0)
        return 0;
    if (len > 0x40000000)
        return -1;
    if (start % PGSIZE != 0)
        return -1;
    uint64 nums = (len + PGSIZE - 1) / PGSIZE, va = start;
    struct proc *p = curr_proc();
    // if [addr, addr + len) 存在被映射, return -1;
    // 申请 (len + 4095) / 4096页内存，如果内存不够，return -1
    // 进行虚存映射
    for (uint64 i = 0; i < nums; ++i) {
        if (useraddr(p->pagetable, va) == 0)
            return -1;
        uvmunmap(p->pagetable, va, 1, 1);
        va += PGSIZE;
    }
    return nums * PGSIZE;
}

uint64 console_read(uint64 va, uint64 len) {
    struct proc *p = curr_proc();
    char str[200];
    for(int i = 0; i < len; ++i) {
        int c = console_getchar();
        str[i] = c;
    }
    copyout(p->pagetable, va, str, len);
    return len;
}

uint64 sys_write(int fd, uint64 va, uint64 len) {
    if(fd <= 2) {
        return console_write(va, len);
    }
    struct proc *p = curr_proc();
    if (fd > 15)
        return -1;
    struct file *f = p->files[fd];
    if(f->type == FD_PIPE) {
        info("write to pipe at %p\n", f->pipe);
        return pipewrite(f->pipe, va, len);
    }
    error("unknown file type %d\n", f->type);
    panic("syswrite: unknown file type\n");
    return -1;
}

uint64 sys_read(int fd, uint64 va, uint64 len) {
    if(fd == 0) {
        return console_read(va, len);
    }
    struct proc *p = curr_proc();
    if (fd > 15)
        return -1;
    struct file *f = p->files[fd];
    if(f->type == FD_PIPE) {
        info("read to pipe at %p\n", f->pipe);
        return piperead(f->pipe, va, len);
    }
    error("unknown file type %d\n", f->type);
    panic("sysread: unknown file type\n");
    return -1;
}

uint64
sys_pipe(uint64 fdarray) {
    info("init pipe\n");
    struct proc *p = curr_proc();
    uint64 fd0, fd1;
    struct file* f0, *f1;
    if(f0 < 0 || f1 < 0) {
        return -1;
    }
    f0 = filealloc();
    f1 = filealloc();
    if(pipealloc(f0, f1) < 0)
        return -1;
    fd0 = fdalloc(f0);
    fd1 = fdalloc(f1);
    if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
       copyout(p->pagetable, fdarray+sizeof(uint64), (char *)&fd1, sizeof(fd1)) < 0){
        fileclose(f0);
        fileclose(f1);
        p->files[fd0] = 0;
        p->files[fd1] = 0;
        return -1;
    }
    return 0;
}

uint64 sys_exit(int code) {
    exit(code);
    return 0;
}

uint64 sys_sched_yield() {
    yield();
    return 0;
}

uint64 sys_getpid() {
    return curr_proc()->pid;
}

uint64 sys_clone() {
    info("fork!\n");
    return fork();
}

uint64 sys_exec(uint64 va) {
    struct proc* p = curr_proc();
    char name[200];
    copyinstr(p->pagetable, name, va, 200);
    info("sys_exec %s\n", name);
    return exec(name);
}

uint64 sys_wait(int pid, uint64 va) {
    struct proc* p = curr_proc();
    int* code = (int*)useraddr(p->pagetable, va);
    return wait(pid, code);
}

uint64 sys_times() {
    return get_time_ms();
}

uint64 sys_close(int fd) {
    if(fd == 0)
        return 0;
    struct proc *p = curr_proc();
    if (fd > 15)
        return 0;
    struct file *f = p->files[fd];
    if(f->type != FD_PIPE) {
        error("unknown file type %d\n", f->type);
        panic("fileclose: unknown file type\n");
    }
    fileclose(f);
    p->files[fd] = 0;
    return 0;
}

uint64 sys_spawn(uint64 va) {
    struct proc* p = curr_proc();
    char name[200];
    copyinstr(p->pagetable, name, va, 200);
    info("sys_spawn %s\n", name);
    return spawn(name);
}

uint64 sys_mail_read(uint64 va, int len) {
    trace("mail read start %d\n", len);
    struct proc* p = curr_proc();
    struct mail* mails = &(p->mails);
    if (mails->nread == mails->nwrite)
        return -1;
    if (len == 0)
        return 0;
    int index = mails->nread % MAILNUM;
    len = min(mails->size[index], len);
    if (copyout(p->pagetable, va, mails->data[index], len) < 0)
        return -1;
    mails->nread += 1;
    trace("mail read %d %d %d\n", index, len, mails->data[index][0]);
    return len;
}

uint64 sys_mail_write(int pid, uint64 va, int len) {
    trace("mail write start %d %d\n", pid, len);
    struct proc* p = get_proc_by_pid(pid);
    struct proc* currp = curr_proc();
    if (p == 0)
        return -1;
    struct mail* mails = &(p->mails);
    if (mails->nread + MAILNUM == mails->nwrite)
        return -1;
    if (len == 0)
        return 0;
    int index = mails->nwrite % MAILNUM;
    len = min(256, len);
    if (copyin(currp->pagetable, mails->data[index], va, len) < 0)
        return -1;
    mails->nwrite += 1;
    mails->size[index] = len;
    trace("mail write %d %d %d %d\n", pid, index, len, mails->data[index][0]);
    return len;
}

void syscall() {
    struct proc *p = curr_proc();
    struct trapframe *trapframe = p->trapframe;
    int id = trapframe->a7, ret;
    uint64 args[7] = {trapframe->a0, trapframe->a1, trapframe->a2, trapframe->a3, trapframe->a4, trapframe->a5, trapframe->a6};
    trace("syscall %d args:%p %p %p %p %p %p %p\n", id, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
    switch (id) {
        case SYS_write:
            ret = sys_write(args[0], args[1], args[2]);
            break;
        case SYS_read:
            ret = sys_read(args[0], args[1], args[2]);
            break;
        case SYS_exit:
            ret = sys_exit(args[0]);
            break;
        case SYS_sched_yield:
            ret = sys_sched_yield();
            break;
        case SYS_getpid:
            ret = sys_getpid();
            break;
        case SYS_clone: // SYS_fork
            ret = sys_clone();
            break;
        case SYS_execve:
            ret = sys_exec(args[0]);
            break;
        case SYS_wait4:
            ret = sys_wait(args[0], args[1]);
            break;
        case SYS_times:
            ret = sys_times();
            break;
        case SYS_pipe2:
            ret = sys_pipe(args[0]);
            break;
        case SYS_close:
            ret = sys_close(args[0]);
            break;
        case SYS_gettimeofday:
            ret = sys_gettimeofday((struct TimeVal *)args[0], args[1]);
            break;
        case SYS_setpriority:
            ret = sys_setpriority(args[0]);
            break;
        case SYS_munmap:
            ret = sys_munmap(args[0], args[1]);
            break;
        case SYS_mmap:
            ret = sys_mmap(args[0], args[1], args[2]);
            break;
        case SYS_spawn:
            ret = sys_spawn(args[0]);
            break;
        case SYS_mail_read:
            ret = sys_mail_read(args[0], args[1]);
            break;
        case SYS_mail_write:
            ret = sys_mail_write(args[0], args[1], args[2]);
            break;
        default:
            ret = -1;
            warn("unknown syscall %d\n", id);
    }
    trapframe->a0 = ret;
    trace("syscall ret %d\n", ret);
}
