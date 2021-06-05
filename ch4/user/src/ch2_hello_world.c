#include <stdio.h>
#include <unistd.h>

/// 正确输出：
/// Hello world from user mode program!
/// Test hello_world OK!

int main(void)
{
    puts("Hello world from user mode program!\nTest hello_world OK!");
    return 0;
}