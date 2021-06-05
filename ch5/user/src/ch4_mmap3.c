#include <stdio.h>
#include <unistd.h>
#include <stddef.h>
#include <stdlib.h>

/*
理想结果：对于错误的 mmap 返回 -1，最终输出 Test 04_4 test OK!
*/

int main()
{
    uint64 start = 0x10000000;
    uint64 len = 4096;
    int prot = 3;
    assert(len == mmap((void *)start, len, prot));
    assert(mmap((void *)(start - len), len + 1, prot) == -1);
    assert(mmap((void *)(start + len + 1), len, prot) == -1);
    assert(mmap((void *)(start + len), len, 0) == -1);
    assert(mmap((void *)(start + len), len, prot | 8) == -1);
    puts("Test 04_4 test OK!");
    return 0;
}