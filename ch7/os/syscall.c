#include "defs.h"
#include "fcntl.h"
#include "syscall_ids.h"
#include "trap.h"
#include "fs.h"
#include "proc.h"
#include "riscv.h"

struct TimeVal {
	uint64 sec;	// 自 Unix 纪元起的秒数
	uint64 usec;	// 微秒，也就是除了秒的那点零头
};

struct Stat {
	uint64 dev;		// 文件所在磁盘驱动器号，不考虑 
	uint64 ino;		// inode 文件所在 inode 编号
	uint32 mode;	// 文件类型
	uint32 nlink;	// 硬链接数量，初始为1
	uint64 pad[7];	// 无需考虑，为了兼容性设计
};

// 文件类型只需要考虑:
#define DIR 0x040000		// directory
#define FILE 0x100000		// ordinary regular file

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

uint64 sys_gettimeofday(uint64 va, int tz) {
    // debug("sys_gettimeofday start\n");
    struct proc *p = curr_proc();
    struct TimeVal ts1;
    uint64 cycle = get_cycle();
    ts1.usec = (cycle % 12500000) *2 / 25;
    ts1.sec = cycle / 12500000;
    copyout(p->pagetable, va, (char *)(&ts1), sizeof(struct TimeVal));
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
    for(int i = 0; i < MIN(len, 200); ++i) {
        int c = console_getchar();
        str[i] = c;
    }
    copyout(p->pagetable, va, str, len);
    return len;
}

uint64 sys_write(int fd, uint64 va, uint64 len) {
    if (fd <= 2) {
        return console_write(va, len);
    }
    struct proc *p = curr_proc();
    if (fd > 15)
        return -1;
    struct file *f = p->files[fd];
    if (f->type == FD_PIPE) {
        return pipewrite(f->pipe, va, len);
    } else if (f->type == FD_INODE) {
        return filewrite(f, va, len);
    }
    error("unknown file type %d\n", f->type);
    return -1;
}

uint64 sys_read(int fd, uint64 va, uint64 len) {
    if (fd <= 2) {
        return console_read(va, len);
    }
    struct proc *p = curr_proc();
    if (fd > 15)
        return -1;
    struct file *f = p->files[fd];
    if (f->type == FD_PIPE) {
        return piperead(f->pipe, va, len);
    } else if (f->type == FD_INODE) {
        return fileread(f, va, len);
    }
    error("unknown file type %d\n", f->type);
    return -1;
}

uint64
sys_pipe(uint64 fdarray) {
    info("init pipe\n");
    struct proc *p = curr_proc();
    uint64 fd0, fd1;
    struct file *f0, *f1;
    if (f0 < 0 || f1 < 0) {
        return -1;
    }
    f0 = filealloc();
    f1 = filealloc();
    if (pipealloc(f0, f1) < 0)
        return -1;
    fd0 = fdalloc(f0);
    fd1 = fdalloc(f1);
    if (copyout(p->pagetable, fdarray, (char *) &fd0, sizeof(fd0)) < 0 ||
        copyout(p->pagetable, fdarray + sizeof(uint64), (char *) &fd1, sizeof(fd1)) < 0) {
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
    return fork();
}

uint64 sys_exec(uint64 va) {
    struct proc* p = curr_proc();
    char name[200];
    copyinstr(p->pagetable, name, va, 200);
    return exec(name);
}

uint64 sys_wait(int pid, uint64 va) {
    struct proc *p = curr_proc();
    int *code = (int *) useraddr(p->pagetable, va);
    return wait(pid, code);
}

uint64 sys_times() {
    uint64 time = get_time_ms();
    return time;
}

uint64 sys_close(int fd) {
    if (fd == 0)
        return 0;
    struct proc *p = curr_proc();
    if (fd > 15)
        return 0;
    struct file *f = p->files[fd];
    fileclose(f);
    p->files[fd] = 0;
    return 0;
}

uint64 sys_openat(uint64 va, uint64 omode, uint64 _flags) {
    struct proc *p = curr_proc();
    char path[200];
    copyinstr(p->pagetable, path, va, 200);
    return fileopen(path, omode);
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

uint64 sys_linkat(int olddirfd, uint64 oldva, int newdirfd, uint64 newva, uint flags) {
    struct proc *p = curr_proc();
    char oldpath[200], newpath[200];
    copyinstr(p->pagetable, oldpath, oldva, 200);
    copyinstr(p->pagetable, newpath, newva, 200);
    trace("linkat %s, %s\n", oldpath, newpath);
    if (strncmp(oldpath, newpath, DIRSIZ) == 0) {
        warn("linkat oldpath == newpath: %s\n", oldpath);
        return -1;
    }
    struct inode *ip, *dp;
    dp = root_dir();
    ip = namei(oldpath);
    if (dirlink(dp, newpath, ip->inum) < 0) {
        warn("linkat exists: %s\n", newpath);
    }
    ip->nlink++;
    iupdate(ip);
    iput(ip);
    iput(dp);
    return 0;
}

uint64 sys_unlinkat(int dirfd, uint64 va, uint flags) {
    struct proc *p = curr_proc();
    char path[200];
    struct inode *dp;
    dp = root_dir();
    copyinstr(p->pagetable, path, va, 200);
    trace("unlinkat %s\n", path);
    uint64 ret = dirunlink(dp, path);
    iput(dp);
    return ret;
}

uint64 sys_fstat(int fd, uint64 va) {
    struct proc *p = curr_proc();
    struct Stat st;
    if ((fd < 0) || (fd > 15))
        return -1;
    struct file *f = p->files[fd];
    if (f->type != FD_INODE) {
        return -1;
    }
    struct inode *ip = f->ip;
    st.dev = ip->dev;
    st.ino = ip->inum;
    st.nlink = ip->nlink;
    if (ip->type == T_DIR)
        st.mode = DIR;
    else if (ip->type == T_FILE)
        st.mode = FILE;
    else {
        warn("unknown inode type: %d\n", ip->type);
        st.mode = FILE;
    }
    copyout(p->pagetable, va, (char *)(&st), sizeof(struct Stat));
    trace("stat %d, %d, %d, %x\n", st.dev, st.ino, st.nlink, st.mode);
    return 0;
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
        case SYS_openat:
            ret = sys_openat(args[0], args[1], args[2]);
            break;
        case SYS_close:
            ret = sys_close(args[0]);
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
        case SYS_clone:// SYS_fork
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
        case SYS_gettimeofday:
            ret = sys_gettimeofday(args[0], args[1]);
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
        case SYS_linkat:
            ret = sys_linkat(args[0], args[1], args[2], args[3], args[4]);
            break;
        case SYS_unlinkat:
            ret = sys_unlinkat(args[0], args[1], args[2]);
            break;
        case SYS_fstat:
            ret = sys_fstat(args[0], args[1]);
            break;
        default:
            ret = -1;
            warn("unknown syscall %d\n", id);
    }
    trapframe->a0 = ret;
    trace("syscall ret %d\n", ret);
}