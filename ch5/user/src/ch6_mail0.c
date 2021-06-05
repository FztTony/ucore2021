#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

const int BUF_LEN = 256;

/// 测试邮箱基本功能，输出　mail0 test OK! 就算正确。

int main()
{
    int pid = getpid();
    char buffer0[27];
    memset(buffer0, 'a', sizeof(buffer0));
    assert(mailwrite(pid, buffer0, sizeof(buffer0)) == sizeof(buffer0));
    char buffer1[BUF_LEN + 1];
    memset(buffer1, 'b', sizeof(buffer1));
    assert(mailwrite(pid, buffer1, BUF_LEN + 1) == BUF_LEN);
    char buf[BUF_LEN];
    memset(buf, 0, sizeof(buf));
    assert(mailread(buf, BUF_LEN) == sizeof(buffer0));
    assert(strncmp(buf, buffer0, sizeof(buffer0)) == 0);
    assert(mailread(buf, 27) == 27);
    assert(strncmp(buf, buffer1, 27) == 0);
    puts("mail0 test OK!");
    return 0;
}