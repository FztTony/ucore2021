#include <stdio.h>
#include <unistd.h>

/*
理想结果：得到进程 pid，注意要关注 pid 是否符合内核逻辑，不要单纯以 Test OK! 作为判断。
*/

int main()
{
    int pid = getpid();
    printf("Test getpid OK! pid = %d\n", pid);
    return 0;
}