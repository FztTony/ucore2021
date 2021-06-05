#include "riscv.h"

uint64 get_cycle() {
    return r_time();
}

/// Enable timer interrupt
void timerinit() {
    // Enable supervisor timer interrupt
    w_sie(r_sie() | SIE_STIE);
    set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer() {
    // 100Hz @ QEMU
    uint64 timebase = 250000;
    set_timer(get_cycle() + timebase);
}