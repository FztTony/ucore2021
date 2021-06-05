#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdlib.h>

const unsigned char LF = 0x0a;
const unsigned char CR = 0x0d;
const unsigned char DL = 0x7f;
const unsigned char BS = 0x08;

char line[100] = {};

int top = 0;

void push(char c) {
    line[top++] = c;
}

void pop() {
    --top;
}

int is_empty() {
    return top == 0;
}

void clear() {
    top = 0;
}

int main() {
    printf("C user shell\n");
    printf(">> ");
    fflush(stdout);
    while (1) {
        char c = getchar();
        switch (c) {
            case LF:
            case CR:
                printf("\n");
                if (!is_empty()) {
                    push('\0');
                    int pid = fork();
                    if (pid == 0) {
                        // child process
                        if (exec(line) < 0) {
                            printf("no such program\n");
                            exit(0);
                        }
                        panic("unreachable!");
                    } else {
                        int xstate = 0;
                        int exit_pid = 0;
                        exit_pid = waitpid(pid, &xstate);
                        assert(pid == exit_pid);
                        printf("Shell: Process %d exited with code %d\n", pid, xstate);
                    }
                    clear();
                }
                printf(">> ");
                fflush(stdout);
                break;
            case BS:
            case DL:
                if (!is_empty()) {
                    putchar(BS);
                    printf(" ");
                    putchar(BS);
                    fflush(stdout);
                    pop();
                }
                break;
            default:
                putchar(c);
                fflush(stdout);
                push(c);
                break;
        }
    }
    return 0;
}
