#ifndef __STDLIB_H__
#define __STDLIB_H__

void panic(char *);

#ifndef assert
#define assert(f) \
    if (!(f))     \
    exit(-1)
#endif

#endif //__STDLIB_H__
