#include <stdio.h>
#include <unistd.h>

int main(void)
{
    asm volatile("sret");
    return 0;
}