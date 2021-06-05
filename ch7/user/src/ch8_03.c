#include "ch8.h"

int main() {
    // mmap test
    int prot = 3;
    mmap((void *) 0, 0x4000ULL, prot);
    puts("mmap ...");
    // get_time test
    sys_get_time((void *)get_pc() + 8, -1);
    // fstat test
    char *fname = "fname1-ch8_03";
    int fd = open(fname, O_CREATE | O_WRONLY);
    fstat(fd, (void *)get_pc() + 6);
    puts("fstat ...");
    // read test
    read(stdin, (void *)get_pc() + 8, 0x10);
    puts("read ...");
    // trapframe test
    fstat(fd, (void*)TRAPFRAME);
    puts("fstat2 ...");
    return 0;
}