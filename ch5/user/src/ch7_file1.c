#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stddef.h>

/// 测试 fstat，输出　Test fstat OK! 就算正确。

int main()
{
    char *fname = "fname1";
    int fd = open(fname, O_CREATE | O_WRONLY);
    assert(fd > 0);
    Stat stat;
    int ret = fstat(fd, &stat);
    assert(ret == 0);
    assert(stat.mode == FILE);
    assert(stat.nlink == 1);
    close(fd);
    // unlink(fname);
    // It's recommended to rebuild the disk image. This program will not clean the file "fname1".
    puts("Test fstat OK!");
    return 0;
}