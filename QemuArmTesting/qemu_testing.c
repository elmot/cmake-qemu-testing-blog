#include <stdlib.h>
#include "qemu_testing.h"
extern void qemu_testing_setup(void);
extern void qemu_testing_teardown(void);

int main() {
    qemu_testing_setup();
    int resultCode = test_main();
    qemu_testing_teardown();
    exit(resultCode);
}

