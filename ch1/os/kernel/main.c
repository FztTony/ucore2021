#include "defs.h"

extern char stext[];
extern char etext[];
extern char srodata[];
extern char erodata[];
extern char sdata[];
extern char edata[];
extern char sbss[];
extern char ebss[];

void clean_bss() {
    char* p;
    for(p = sbss; p < ebss; ++p)
        *p = 0;
}

void main() {
    clean_bss();
    printf("\n");
    printf("hello world!\n");
    info("stext: %p, etext: %p\n", stext, etext);
    info("sroda: %p, eroda: %p\n", srodata, erodata);
    info("sdata: %p, edata: %p\n", sdata, edata);
    info("sbss : %p, ebss : %p\n", sbss, ebss);
    warn("this is a warning\n");
    error("this is an error\n");
    debug("this is a debug\n");
    trace("this is a trace\n");
    printf("this is a printf\n");
    printf("\n");
    shutdown();
}
