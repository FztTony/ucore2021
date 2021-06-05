#include "types.h"
#include "file.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"
#include "fcntl.h"

#define FILE_MAX (128*16)
struct file filepool[FILE_MAX];

void
fileclose(struct file *f)
{
    if(f->ref < 1)
        panic("fileclose");
    if(--f->ref > 0) {
        return;
    }

    if(f->type == FD_PIPE){
        pipeclose(f->pipe, f->writable);
    } else if(f->type == FD_INODE) {
        iput(f->ip);
    }

    f->off = 0;
    f->readable = 0;
    f->writable = 0;
    f->ref = 0;
    f->type = FD_NONE;
}

struct file* filealloc() {
    for(int i = 0; i < FILE_MAX; ++i) {
        if(filepool[i].ref == 0) {
            filepool[i].ref = 1;
            return &filepool[i];
        }
    }
    return 0;
}

extern int PID;

static struct inode *
create(char *path, short type) {
    struct inode *ip, *dp;
    dp = root_dir();
    ivalid(dp);
    if ((ip = dirlookup(dp, path, 0)) != 0) {
        trace("create a exist file\n");
        iput(dp);
        ivalid(ip);
        if (type == T_FILE && ip->type == T_FILE)
            return ip;
        iput(ip);
        return 0;
    }
    if ((ip = ialloc(dp->dev, type)) == 0)
        panic("create: ialloc");

    trace("create dinod and inode type = %d\n", type);
    
    ivalid(ip);
    iupdate(ip);
    if(dirlink(dp, path, ip->inum) < 0)
        panic("create: dirlink");

    iput(dp);
    return ip;
}

extern int PID;

int fileopen(char *path, uint64 omode) {
    int fd;
    struct file *f;
    struct inode *ip;
    if (omode & O_CREATE) {
        trace("create\n");
        ip = create(path, T_FILE);
        trace("%d\n", ip->nlink);
        if (ip == 0) {
            return -1;
        }
    } else {
        trace("open\n");
        if ((ip = namei(path)) == 0) {
            return -1;
        }
        ivalid(ip);
    }
    if (ip->type != T_FILE)
        panic("unsupported file inode type\n");
    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
        if (f)
            fileclose(f);
        iput(ip);
        return -1;
    }
    // only support FD_INODE
    f->type = FD_INODE;
    f->off = 0;
    f->ip = ip;
    f->readable = !(omode & O_WRONLY);
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    if ((omode & O_TRUNC) && ip->type == T_FILE) {
        itrunc(ip);
    }
    return fd;
}

uint64 filewrite(struct file* f, uint64 va, uint64 len) {
    int r;
    ivalid(f->ip);
    if ((r = writei(f->ip, 1, va, f->off, len)) > 0)
        f->off += r;
    return r;
}

uint64 fileread(struct file* f, uint64 va, uint64 len) {
    int r;
    ivalid(f->ip);
    if ((r = readi(f->ip, 1, va, f->off, len)) > 0)
        f->off += r;
    return r;
}