#include "defs.h"

extern char ekernel[];
extern char s_bss[];
extern char e_bss[];

void clean_bss() {
    char* p;
    for(p = s_bss; p < e_bss; ++p)
        *p = 0;
}

void main() {
    clean_bss();
    trapinit();
    batchinit();
    procinit();
    timerinit();
    run_all_app();
    printf("start scheduler!\n");
    scheduler();
}