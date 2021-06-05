#include "ch8.h"

int N = 10;

int main() {
    int i;
    for(i = 0; i < N; ++i)
        fork();
    return 0;
}