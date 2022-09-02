#include <stdio.h>
#include <stdlib.h>
#include "qemu_testing.h"
/**
 * ARMC[0..85][_DSP][_fpu].h file is externally included via CMake
 */
extern void initialise_monitor_handles(void);

int main() {
    SysTick->LOAD = 0xFFFFFF;
    SysTick->VAL = 0;
    SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk |
                    //                     SysTick_CTRL_TICKINT_Msk   |
                    SysTick_CTRL_ENABLE_Msk;
    initialise_monitor_handles();
    uint32_t timeCnt1 = SysTick->VAL;
    int resultCode = test_main();
    uint32_t timeCnt2 = SysTick->VAL;
    printf("Cycles count: %ld\n", (timeCnt1 - timeCnt2));
    exit(resultCode);
}

void HardFault_Handler(void) {
    fputs("Hard Fault encountered", stderr);
    exit(13);
}

void MemManage_Handler(void) {
    fputs("MemManage Fault encountered", stderr);
    exit(14);
}

void BusFault_Handler(void) {
    fputs("Bus Fault encountered", stderr);
    exit(15);
}

void UsageFault_Handler(void) {
    fputs("Usage Fault encountered", stderr);
    exit(16);
}

void SecureFault_Handler(void) {
    fputs("Secure Fault encountered", stderr);
    exit(17);
}

void SysTick_Handler() {
    //todo long long timer bitness
}
