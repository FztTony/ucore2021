#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stddef.h>

/// 测试 link/unlink，输出　Test link OK! 就算正确。

int main()
{
    char *test_str = "Hello, world!";
    char *fname = "fname2";
    char *lname0 = "linkname0";
    char *lname1 = "linkname1";
    char *lname2 = "linkname2";

    int fd = open(fname, O_CREATE | O_WRONLY);
    link(fname, lname0);
    Stat stat;
    fstat(fd, &stat);
    assert(stat.nlink == 2);
    link(fname, lname1);
    link(fname, lname2);
    fstat(fd, &stat);
    assert(stat.nlink == 4);
    write(fd, test_str, strlen(test_str));
    close(fd);

    unlink(fname);
    fd = open(lname0, O_RDONLY);
    Stat stat2;
    char buf[100];
    memset(buf, 0, sizeof(buf));
    int read_len = read(fd, &buf, sizeof(buf));
    assert(strncmp(test_str, buf, read_len) == 0);
    fstat(fd, &stat2);
    assert(stat2.dev == stat.dev);
    assert(stat2.ino == stat.ino);
    assert(stat2.nlink == 3);
    unlink(lname1);
    unlink(lname2);
    fstat(fd, &stat2);
    assert(stat2.nlink == 1);
    close(fd);
    unlink(lname0);
    // It's Ok if you don't delete the inode and data blocks.
    puts("Test link OK!");
    return 0;
}