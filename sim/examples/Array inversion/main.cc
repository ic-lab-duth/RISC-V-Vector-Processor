// #include <stdio.h>
#include <stdint.h>
#define N 64

int8_t dst[N] __attribute__((aligned(256)));

int8_t src[N]__attribute__((aligned(256)))={44, 60, 5, 33, 62, 3, 0, 4, 8, 45, 18, 53, 15, 56, 28, 41, 25, 10, 27, 61, 19, 49, 37, 14, 58, 16, 32, 20, 22, 42, 46, 54, 57, 7, 12, 23, 24, 50, 63, 38, 48, 17, 55, 47, 59, 6, 26, 39, 31, 21, 30, 40, 43, 36, 34, 2, 29, 13, 11, 51, 35, 52, 1, 9};

int main(int argc, const char* argv[]) {
    
    #pragma clang loop vectorize(enable)
    for (int i = 0; i < N; ++i) {
        dst[i] = src[N-i-1];
    }


    return 0;
}