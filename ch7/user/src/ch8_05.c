#include "ch8.h"

void sleep_test(int _i) {
    int current_time = get_time();
    unsigned long long sleep_length = current_time * current_time % 1000 + 1000;
    sleep(sleep_length);
}

void heavy_fork_test() {
    for (int i = 0; i < 30; ++i)
        fork_test(sleep_test);
}

int main() {
    heavy_fork_test();
    return 0;
}