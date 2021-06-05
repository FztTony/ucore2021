#include "ch8.h"

const uint64 START = 0x10000;
const uint64 LEN = 0x10000;

void mmap_test(int i) {
    char* a = (void*)START;
    *(a + (hash(i) % LEN)) = 'a';
    *(a + (hash(i + 1) % LEN));
}

int main() {
    int prot = 3;
    mmap((void*)START, LEN, prot);
    fork_test(mmap_test);
    return 0;
}