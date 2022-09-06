#include <stdio.h>
#include <stdlib.h>
#include "qemu_testing.h"
/**
 * ARMC[0..85][_DSP][_fpu].h file is externally included via CMake
 */

/**
 * Semihosting support
 */
extern void initialise_monitor_handles(void);

/**
 * Timing support
 */
#define TIMER_TICKS (1000000)
static volatile uint32_t tickLoopCount = 0;

uint32_t elapsedSysTicks() {
    __disable_irq();
    uint32_t loops = tickLoopCount;
    __enable_irq();
    return (loops+1) * TIMER_TICKS - SysTick->VAL;
}

int main() {
    initialise_monitor_handles();
    SysTick_Config(TIMER_TICKS);
    SysTick->VAL = 0;
    int resultCode = test_main();
    printf("Cycles count: %ld\n", elapsedSysTicks());
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
    __disable_irq();
    tickLoopCount++;
    __enable_irq();
}

