#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/// 辅助测例，运行所有其他测例。

char *TESTS[] = {
    "ch2_hello_world\0",
    "ch2_power\0",
    "ch2_write1\0",
    "ch3_0_setprio\0",
    "ch3_0_sleep\0",
    "ch3_0_sleep1\0",
    "ch4_mmap0\0",
    "ch4_mmap1\0",
    "ch4_mmap2\0",
    "ch4_mmap3\0",
    "ch4_unmap\0",
    "ch4_unmap2\0",
    "ch5_getpid\0",
    "ch5_spawn0\0",
    "ch5_spawn1\0",
};

int main()
{
    int num_test = sizeof(TESTS) / sizeof(char *);
    for (int i = 0; i < num_test; ++i)
    {
        char *test = TESTS[i];
        printf("Usertests: Running %s\n", test);
        int pid = spawn(test);
        int xstate = 0;
        int wait_pid = waitpid(pid, &xstate);
        assert(pid == wait_pid);
        printf("Usertests: Test %s in Process %d exited with code %d\n", test, pid, xstate);
    }
    puts("ch5 Usertests passed!");
    return 0;
}
