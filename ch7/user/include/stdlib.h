#ifndef __STDLIB_H__
#define __STDLIB_H__

#include "stddef.h"

void panic(char *);

#ifndef assert
#define assert(f) \
    if (!(f))     \
    exit(-1)
#endif

void srand(int s);
uint32 rand();

#endif //__STDLIB_H__
