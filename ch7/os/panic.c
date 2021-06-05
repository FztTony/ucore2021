#include "defs.h"

void loop() {
    for(;;);
}

void panic(char *s)
{
    error("panic: %s", s);
    shutdown();
}