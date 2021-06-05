#include "ch8.h"

const uint64 UNUSED_START = 0x8000;
const uint64 N = 0x800;
const uint64 LEN = 0x10000;

int main() {
    int i;
    int prot = 3;
    for(i = 0; i < N * 2; ++i)
        mmap((void *)(UNUSED_START + i * LEN), LEN, prot); 
    return 0;
}