#include <stdio.h>
#include "qemu_testing.h"

float factorial(float f) {
    float result = 1;
    for (; f > 0; f -= 1.0f) {
        result *= f;
    }
    return result;
}

int test_main() {
    float f=25.0f;
    printf("Factorial of %f is %f\n", f, factorial(f));
    return 0;
}