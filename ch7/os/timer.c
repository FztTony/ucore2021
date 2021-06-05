#include "riscv.h"
#include "defs.h"

const uint64 TICKS_PER_SEC = 100;
const uint64 MSEC_PER_SEC = 1000;
const uint64 CPU_FREQ = 12500000;

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
    const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
    set_timer(get_cycle() + timebase);
}

uint64 get_time_ms() {
    uint64 time = get_cycle();
    return time / (CPU_FREQ / MSEC_PER_SEC);
}