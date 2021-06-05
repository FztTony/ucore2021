#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

const int BUF_LEN = 256;
const int MAIL_MAX = 16;
const uint64 BAD_ADDRESS = 0x90000000ULL;

/// 邮箱错误参数测试，输出 mail3 test OK! 就算正确。

int main()
{
    int pid = getpid();
    char *null = (char *)BAD_ADDRESS;
    assert(mailwrite(pid, null, 10) == -1);
    char empty[0];
    assert(mailwrite(pid, empty, 0) == 0);
    assert(mailread(empty, 0) == -1);
    char buffer0[BUF_LEN];
    memset(buffer0, 'a', BUF_LEN);
    for (int _ = 0; _ < MAIL_MAX; ++_)
    {
        assert(mailwrite(pid, buffer0, BUF_LEN) == BUF_LEN);
    }
    assert(mailwrite(pid, empty, 0) == -1);
    assert(mailread(empty, 0) == 0);
    assert(mailwrite(pid, empty, 0) == -1);
    puts("mail3 test OK!");
    return 0;
}