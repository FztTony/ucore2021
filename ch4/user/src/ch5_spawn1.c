#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/// 程序行为：先后产生 3 个有特定返回值的程序，检查 waitpid 能够获取正确返回值。

/// 理想输出：
/// new child i
/// Test wait OK!
/// Test waitpid OK!

int main()
{
    int cpid = spawn("ch5_exit0\0");
    assert(cpid >= 0); // "child pid invalid"
    printf("new child %d\n", cpid);
    int exit_code = 0;
    int exit_pid = wait(&exit_code);
    assert(exit_pid == cpid);   // "error exit pid"
    assert(exit_code == 66778); // "error exit code"
    puts("Test wait OK!\n");
    int cpid0 = spawn("ch5_exit0\0");
    int cpid1 = spawn("ch5_exit1\0");
    exit_pid = waitpid(cpid1, &exit_code);
    assert(exit_pid == cpid1); // "error exit pid"
    assert(exit_code == -233); // "error exit code"
    exit_pid = wait(&exit_code);
    assert(exit_pid == cpid0);  // "error exit pid"
    assert(exit_code == 66778); // "error exit code"
    puts("Test waitpid OK!");
    return 0;
}