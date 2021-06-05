#include "defs.h"
#include "trap.h"

static int app_cur, app_num;
static uint64* app_info_ptr;
extern char _app_num[], userret[], boot_stack_top[], ekernel[];
const uint64 BASE_ADDRESS = 0x80400000, MAX_APP_SIZE = 0x20000;

void batchinit() {
    if((uint64)ekernel >= BASE_ADDRESS) {
        panic("kernel too large...\n");
    }
    app_info_ptr = (uint64*) _app_num;
    app_cur = -1;
    app_num = *app_info_ptr;
}

__attribute__ ((aligned (4096))) char user_stack[4096];
__attribute__ ((aligned (4096))) char trap_page[4096];

int load_app(uint64* info) {
    uint64 start = info[0], end = info[1], length = end - start;
    memset((void*)BASE_ADDRESS, 0, MAX_APP_SIZE);
    memmove((void*)BASE_ADDRESS, (void*)start, length);
    return length;
}

int run_next_app() {
    struct trapframe* trapframe = (struct trapframe*)trap_page;
    app_cur++;
    app_info_ptr++;
    if(app_cur >= app_num) {
        return -1;
    }
    printf("load and run app %d\n", app_cur);
    uint64 length = load_app(app_info_ptr);
    memset(trapframe, 0, 4096);
    trapframe->epc = BASE_ADDRESS;
    printf("bin range = [%p, %p)\n", *app_info_ptr, *app_info_ptr + length);
    trapframe->sp = (uint64) user_stack + 4096;
    usertrapret(trapframe, (uint64)boot_stack_top);
    return 0;
}