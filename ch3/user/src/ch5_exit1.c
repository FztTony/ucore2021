#include <stdlib.h>
#include <unistd.h>

/*
辅助测例，正常退出，不输出 FAIL 即可。
*/

int main()
{
    exit(-233);
    panic("FAIL: T.T\n");
    return 0;
}