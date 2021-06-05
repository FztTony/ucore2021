#include "types.h"
#include "file.h"
#include "proc.h"
#include "defs.h"

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