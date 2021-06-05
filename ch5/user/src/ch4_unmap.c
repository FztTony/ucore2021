#include <stdio.h>
#include <unistd.h>
#include <stddef.h>
#include <stdlib.h>

/*
理想结果：输出 Test 04_5 ummap OK!
*/

int main()
{
    uint64 start = 0x10000000;
    uint64 len = 4096;
    int prot = 3;
    assert(len == mmap((void *)start, len, prot));
    assert(mmap((void *)(start + len), len * 2, prot) == (len * 2));
    assert(munmap((void *)start, len) == len);
    assert(mmap((void *)(start - len), len + 1, prot) == (len * 2));
    for (uint64 i = (start - len); i < (start + len * 3); ++i)
    {
        uint8 *addr = (uint8 *)i;
        *addr = (uint8)i;
    }
    for (uint64 i = (start - len); i < (start + len * 3); ++i)
    {
        uint8 *addr = (uint8 *)i;
        assert(*addr == (uint8)i);
    }
    puts("Test 04_5 ummap OK!");
    return 0;
}