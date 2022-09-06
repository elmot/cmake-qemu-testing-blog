#ifndef CMAKE_QEMU_TESTING_BLOG_QEMU_TESTING_H
#define CMAKE_QEMU_TESTING_BLOG_QEMU_TESTING_H

#include "stdint.h"
/** Test suite main class
 *
 * @return test exit code, zero in case of success, non-zero otherwise
 */

extern int test_main(void);

/** Elapsed time from the test start
 *
 * @return test execution time, in terms of qemu internal timer.
 * The value is not precise but good enough to use for performance smoke tests
 */
uint32_t elapsedSysTicks();
#endif //CMAKE_QEMU_TESTING_BLOG_QEMU_TESTING_H
