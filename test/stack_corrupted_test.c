#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "qemu_testing.h"

#define BLOCK_SIZE (20)

void stack_attack() {
    char buf[BLOCK_SIZE];
    sprintf(buf,"%d-%d-%d-%d",1000001,1000002,1000003,1000004);
}

int test_main() {
    puts("Trying to break the stack");
    stack_attack();
    puts("Tried to break the stack");
    return 0;
}


