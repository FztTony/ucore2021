#ifndef __FILE_H__
#define __FILE_H__

#include "types.h"
#include "fs.h"

#define PIPESIZE 512

// in-memory copy of an inode
struct inode {
    uint dev;           // Device number
    uint inum;          // Inode number
    int ref;            // Reference count
    int valid;          // inode has been read from disk?
    short type;         // copy of disk inode
    short nlink;
    uint size;
    uint addrs[NDIRECT+1];
};

// map major device number to device functions.
struct devsw {
    int (*read)(int, uint64, int);
    int (*write)(int, uint64, int);
};

extern struct devsw devsw[];

struct pipe {
    char data[PIPESIZE];
    uint nread;     // number of bytes read
    uint nwrite;    // number of bytes written
    int readopen;   // read fd is still open
    int writeopen;  // write fd is still open
};

// file.h
struct file {
    enum { FD_NONE = 0, FD_PIPE, FD_INODE} type;
    int ref; // reference count
    char readable;
    char writable;
    struct pipe *pipe; // FD_PIPE
    struct inode *ip;  // FD_INODE
    uint off;
};


extern struct file filepool[128 * 16];  // NPROC * PROC_MAX

#endif //!__FILE_H__