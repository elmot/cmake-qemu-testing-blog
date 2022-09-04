#include <stdio.h>
#include "qemu_testing.h"

float factorial(float);

int test_main() {
    float f=25.0f;

    float fFact = factorial(f);
    printf("Factorial of %f is %f\n", f, fFact);
    return fFact == 15511209926324736051118080.0f ? 0 : -1;
}