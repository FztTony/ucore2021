#include "defs.h"

void loop() {
    for(;;);
}

void panic(char *s)
{
    printf("panic: ");
    printf(s);
    printf("\n");
    shutdown();
}