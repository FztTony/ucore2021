#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

const int BUF_LEN = 256;
const int MAIL_MAX = 16;

/// 测试邮箱容量，输出 mail1 test OK! 就算正确。

int main()
{
    int pid = getpid();
    char buffer0[BUF_LEN];
    memset(buffer0, 'a', BUF_LEN);
    for (int _ = 0; _ < MAIL_MAX; ++_)
    {
        assert(mailwrite(pid, buffer0, BUF_LEN) == BUF_LEN);
    }
    assert(mailwrite(pid, buffer0, BUF_LEN) == -1);
    char buf[BUF_LEN];
    memset(buf, 0, BUF_LEN);
    assert(mailread(buf, BUF_LEN) == BUF_LEN);
    assert(mailwrite(pid, buffer0, BUF_LEN) == BUF_LEN);
    assert(mailwrite(pid, buffer0, BUF_LEN) == -1);
    puts("mail1 test OK!");
}