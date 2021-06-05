#include <string.h>
#include <stdio.h>

/*
测试 sys_read()，目前只能从 stdin 读取。
程序行为：接受 N 个键盘输入并最终一齐输出（注意没有输入时不会显示），如果一致就算正确。不要单纯以 Test getchar passed! 作为判断。
*/

const uint64 N = 10;

int main()
{
    printf("please enter %d letters.\n", N);
    char line[N];
    memset(line, 0, N);
    for (int idx = 0; idx < N; ++idx)
    {
        char c = getchar();
        line[idx] = c;
    }
    printf("%d letters entered\n", N);
    for (int idx = 0; idx < N; ++idx)
    {
        putchar(line[idx]);
    }
    puts("Test getchar passed!");
    return 0;
}