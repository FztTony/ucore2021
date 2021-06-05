#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

char *DATA_STRING = "string from data section\n";

/// 正确输出：
/// string from data section
/// strinstring from stack section
/// strin
/// Test write1 OK!

int main(void)
{
    int str_len = strlen(DATA_STRING);
    assert(write(1234, DATA_STRING, str_len) == -1);
    assert(write(stdout, DATA_STRING, str_len) == str_len);
    assert(write(stdout, DATA_STRING, 5) == 5);
    char *stack_string = "string from stack section\n";
    str_len = strlen(stack_string);
    assert(write(stdout, stack_string, str_len) == str_len);
    assert(write(stdout, stack_string, 5) == 5);
    puts("\nTest write1 OK!");
    return 0;
}
