#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

/// 正确输出：（无报错信息）
/// get_time OK! {...}
/// Test sleep OK!

/// 注意不要单纯以 OK! 作为判断，还要注意输出时间是否符合实际。

int main()
{
    int64 current_time = get_time();
    assert(current_time > 0);
    printf("get_time OK! %d\n", current_time);
    int64 wait_for = current_time + 3000;
    while (get_time() < wait_for)
    {
        sched_yield();
    }
    puts("Test sleep OK!");
    return 0;
}