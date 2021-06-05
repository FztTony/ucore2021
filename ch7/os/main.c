#include "defs.h"

extern char s_bss[];
extern char e_bss[];

void clean_bss() {
    char* p;
    for(p = s_bss; p < e_bss; ++p)
        *p = 0;
}

int debug_level = WARN;

void main() {
    clean_bss();
    debug_level = WARN;
    trapinit();
    plicinit();
    kinit();
    procinit();
    kvminit();
    batchinit();
    plicinit();
    binit();
    virtio_disk_init();
    fsinit();
    timerinit();
    run_all_app();
    info("start scheduler!\n");
    scheduler();
}