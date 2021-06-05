#include <unistd.h>
#include <stdio.h>
#include <stddef.h>

/// 正确输出：（无报错信息）
/// current time_msec = xxx
/// time_msec = xxx after sleeping 100 ticks, delta = xxx ms!
/// Test sleep1 passed!

/// 注意不要单纯以 passed! 作为判断，还要注意时间间隔是否真的在 100 附近，误差要不超过 20%。

int main()
{
    int64 start = get_time();
    printf("current time_msec = %d\n", start);
    sleep(100);
    int64 end = get_time();
    printf("time_msec = %d after sleeping 100 ticks, delta = %dms!\n", end, end - start);
    puts("Test sleep1 passed!");
    return 0;
}