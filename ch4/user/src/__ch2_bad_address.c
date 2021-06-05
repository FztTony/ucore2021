#include <stdio.h>
#include <unistd.h>

int main(void)
{
    int* p = (int*)0;
    *p = 0;
    return 0;
}