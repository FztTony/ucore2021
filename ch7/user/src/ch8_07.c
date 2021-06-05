#include "ch8.h"

void randstr(int seed, char s[20]) {
    srand(seed);
    for(int i = 0; i < 19; i++) {
        s[i] = (char)rand(); 
    }
    s[19] = 0;
}

void file_test(int i) {
    char fname[20];
    randstr(i, fname);
    open(fname, O_CREATE | O_WRONLY);
    unlink(fname);
}

int main() {
    for(int i = 0; i < 65536; ++i)
        file_test(i);
    return 0;
}