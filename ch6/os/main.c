#include "defs.h"

extern char s_bss[];
extern char e_bss[];

void clean_bss() {
    char* p;
    for(p = s_bss; p < e_bss; ++p)
        *p = 0;
}

int debug_level = INFO;

void main() {
    clean_bss();
    trapinit();
    kinit();
    procinit();
    kvminit();
    batchinit();
    timerinit();
    run_all_app();
    info("start scheduler!\n");
    scheduler();
}