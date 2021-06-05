#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <stddef.h>

const int SIZE = 10;
const int P = 3;
const int STEP = 100000;
const int MOD = 10007;

/// 正确输出：
/// 3^10000=5079
/// 3^20000=8202
/// 3^30000=8824
/// 3^40000=5750
/// 3^50000=3824
/// 3^60000=8516
/// 3^70000=2510
/// 3^80000=9379
/// 3^90000=2621
/// 3^100000=2749
/// Test power OK!

int main(void)
{
    int pow[10] = {};
    int index = 0;
    int i, last;
    pow[index] = 1;
    for (i = 1; i <= STEP; ++i)
    {
        last = pow[index];
        index = (index + 1) % SIZE;
        pow[index] = (last * P) % MOD;
        if ((i % 10000) == 0)
        {
            printf("%d^%d=%d\n", P, i, pow[index]);
        }
    }
    puts("Test power OK!");
    return 0;
}
