#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>

/// 正确输出：（无报错信息）
/// Test set_priority OK!

int main()
{
    assert(set_priority(10) == 10);
    assert(set_priority(INT_MAX) == INT_MAX);
    assert(set_priority(0) == -1);
    assert(set_priority(1) == -1);
    assert(set_priority(-10) == -1);
    puts("Test set_priority OK!");
    return 0;
}
