#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

void panic(char *m)
{
    puts(m);
    exit(-100);
}

static int hash(int n) {
    uint64 r = 6364136223846793005ULL * n + 1;
    return r >> 33;
}

static uint32 seed;

void srand(int s) {    
    seed = s;
}

uint32 rand() {
    seed = hash(seed);
    return seed;
}