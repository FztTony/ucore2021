#include <stddef.h>
#include <unistd.h>
#include "syscall.h"

void __write_buffer();
void __clear_buffer();

int open(const char *path, int flags)
{
    return syscall(SYS_openat, path, flags, O_RDWR);
}

int close(int fd)
{
    if(fd == 1) {
        __write_buffer();
        __clear_buffer();
    }
    return syscall(SYS_close, fd);
}

ssize_t read(int fd, void *buf, size_t len)
{
    return syscall(SYS_read, fd, buf, len);
}

ssize_t write(int fd, const void *buf, size_t len)
{
    return syscall(SYS_write, fd, buf, len);
}

int getpid(void)
{
    return syscall(SYS_getpid);
}

int sched_yield(void)
{
    return syscall(SYS_sched_yield);
}

int fork(void)
{
    return syscall(SYS_clone);
}

void exit(int code)
{
    __write_buffer();
    __clear_buffer();
    syscall(SYS_exit, code);
}

int waitpid(int pid, int *code)
{
    return syscall(SYS_wait4, pid, code);
}

int exec(char *name)
{
    return syscall(SYS_execve, name);
}

int64 get_time()
{
    TimeVal time;
    int err = sys_get_time(&time, 0);
    if (err == 0)
    {
        return ((time.sec & 0xffff) * 1000 + time.usec / 1000);
    }
    else
    {
        return -1;
    }
}

int sys_get_time(TimeVal *ts, int tz)
{
    return syscall(SYS_gettimeofday, ts, tz);
}

int sleep(unsigned long long time)
{
    unsigned long long s = get_time();
    while (get_time() < s + time)
    {
        sched_yield();
    }
    return 0;
}

int set_priority(int prio)
{
    return syscall(SYS_setpriority, prio);
}

int mmap(void *start, unsigned long long len, int prot)
{
    return syscall(SYS_mmap, start, len, prot);
}

int munmap(void *start, unsigned long long len)
{
    return syscall(SYS_munmap, start, len);
}

int wait(int *code)
{
    return waitpid(-1, code);
}

int spawn(char *file)
{
    return syscall(SYS_spawn, file);
}

int mailread(void *buf, int len)
{
    return syscall(SYS_mailread, buf, len);
}

int mailwrite(int pid, void *buf, int len)
{
    return syscall(SYS_mailwrite, pid, buf, len);
}

int fstat(int fd, Stat *st)
{
    return syscall(SYS_fstat, fd, st);
}

int sys_linkat(int olddirfd, char *oldpath, int newdirfd, char *newpath, unsigned int flags)
{
    return syscall(SYS_linkat, olddirfd, oldpath, newdirfd, newpath, flags);
}

int sys_unlinkat(int dirfd, char *path, unsigned int flags)
{
    return syscall(SYS_unlinkat, dirfd, path, flags);
}

int link(char *old_path, char *new_path)
{
    return sys_linkat(AT_FDCWD, old_path, AT_FDCWD, new_path, 0);
}

int unlink(char *path)
{
    return sys_unlinkat(AT_FDCWD, path, 0);
}
