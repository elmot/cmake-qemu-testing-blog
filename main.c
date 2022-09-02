#include <stdio.h>
#include <stdlib.h>
/**
 * ARMC[0..85][_DSP][_FP].h file is externally included via CMake
 */
extern void initialise_monitor_handles(void);

float factorial(float f) {
    float result = 1;
    for (; f > 0; f -= 1.0f) {
        result *= f;
    }
    return result;
}

void HardFault_Handler(void)
{
    (void ) HardFault_Handler;
    fprintf(stderr,"Hard Fault!!!");
    exit(13);
}

int main() {
    //todo long long timer bitness
    SysTick->LOAD = 0xFFFFFF;
    SysTick->VAL = 0;
    SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk |
                    //                     SysTick_CTRL_TICKINT_Msk   |
                    SysTick_CTRL_ENABLE_Msk;
    initialise_monitor_handles();
    printf("Hello, World!\n");
    uint32_t cnt1 = SysTick->VAL;
    float f=25.0f;
    printf("Factorial of %f is %f\n", f, factorial(f));
    uint32_t cnt2 = SysTick->VAL;
    printf("Cycles count: %ld\n", (cnt1 - cnt2));
    exit(0);
}
