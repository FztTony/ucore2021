#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

const int BUF_LEN = 256;

// 双进程邮箱测试，最终输出 mail2 test OK! 就算正确。

int main()
{
    int pid = fork();
    if (pid == 0)
    {
        puts("I am child");
        char buffer[BUF_LEN];
        memset(buffer, 0, sizeof(buffer));
        assert(mailread(buffer, BUF_LEN) == -1);
        puts("child read 1 mail fail");
        puts("child sleep 2s");
        sleep(2000);
        for (int i = 0; i < 16; ++i)
        {
            char buffer[BUF_LEN];
            memset(buffer, 0, sizeof(buffer));
            assert(mailread(buffer, BUF_LEN) == BUF_LEN);
            char ans[BUF_LEN];
            memset(ans, i, BUF_LEN);
            assert(strncmp(ans, buffer, BUF_LEN) == 0);
        }
        puts("child read 16 mails succeed");
        assert(mailread(buffer, BUF_LEN) == -1);
        puts("child read 1 mail fail");
        puts("child sleep 1s");
        sleep(1000);
        assert(mailread(buffer, BUF_LEN) == BUF_LEN);
        char ans[BUF_LEN];
        memset(ans, 16, BUF_LEN);
        assert(strncmp(buffer, ans, BUF_LEN) == 0);
        puts("child read 1 mail succeed");
        puts("child exit");
        exit(0);
    }
    puts("I am father");
    puts("father sleep 1s");
    sleep(1000);
    for (int i = 0; i < 16; ++i)
    {
        char buffer[BUF_LEN];
        memset(buffer, i, BUF_LEN);
        assert(mailwrite(pid, buffer, BUF_LEN) == BUF_LEN);
    }
    puts("father write 16 mails succeed");
    char buffer[BUF_LEN];
    memset(buffer, 16, BUF_LEN);
    assert(mailwrite(pid, buffer, BUF_LEN) == -1);
    puts("father wirte 1 mail fail");
    puts("father sleep 1.5s");
    sleep(1500);
    assert(mailwrite(pid, buffer, BUF_LEN) == BUF_LEN);
    puts("father wirte 1 mail succeed");

    int xstate = -100;
    assert(wait(&xstate) > 0);
    assert(xstate == 0);
    puts("mail2 test OK!");
    return 0;
}