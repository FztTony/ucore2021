#include <stdio.h>
#include <unistd.h>

/*
理想结果：6个进程退出时，输出 count 基本正比于 priority
*/

void spin_delay()
{
    int j = 1;
    for (int _ = 0; _ < 10; ++_)
    {
        j = !j;
    }
}

// to get enough accuracy, MAX_TIME (the running time of each process) should > 1000 mseconds.
const int MAX_TIME = 1000;
int count_during(int prio)
{
    uint64 start_time = get_time();
    int acc = 0;
    set_priority(prio);
    for (;;)
    {
        spin_delay();
        acc += 1;
        if (acc % 400 == 0)
        {
            uint64 time = get_time() - start_time;
            if (time > MAX_TIME)
            {
                return acc;
            }
        }
    }
}

int main()
{
    int prio = 5;
    int count = count_during(prio);
    printf("priority = %d, exitcode = %d\n", prio, count);
    return 0;
}