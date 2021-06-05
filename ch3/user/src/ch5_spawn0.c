#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/*
理想结果：生成 MAX_CHILD 个 getpid 的子进程，全部结束后，输出 Test spawn0 OK!
*/

const int MAX_CHILD = 40;

int main()
{
    for (int _ = 0; _ < MAX_CHILD; ++_)
    {
        int cpid = spawn("ch5_getpid\0");
        assert(cpid >= 0); // "child pid invalid"
        printf("new child %d\n", cpid);
    }
    int exit_code = 0;
    for (int _ = 0; _ < MAX_CHILD; ++_)
    {
        assert(wait(&exit_code) > 0); // "wait stopped early"
        assert(exit_code == 0);       // "error exit code"
    }
    assert(wait(&exit_code) < 0); // "wait got too many"
    puts("Test spawn0 OK!");
    return 0;
}