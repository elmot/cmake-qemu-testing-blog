#ifndef CMAKE_QEMU_TESTING_BLOG_QEMU_TESTING_DOCTEST_H
#define CMAKE_QEMU_TESTING_BLOG_QEMU_TESTING_DOCTEST_H
#include "doctest.h"
extern "C" void qemu_testing_setup(void);
extern "C" void qemu_testing_teardown(void);


int main(int argc, char** argv) {
    doctest::Context context;

    // overrides
    context.setOption("no-breaks", true);             // don't break in the debugger when assertions fail
    context.setOption("no-intro", true);             // don't break in the debugger when assertions fail

    int res = context.run(); // run

    if(context.shouldExit()) // important - query flags (and --exit) rely on the user doing this
        return res;          // propagate the result of the tests

    int client_stuff_return_code = 0;
    // your program - if the testing framework is integrated in your production code

    return res + client_stuff_return_code; // the result from doctest is propagated here as well
}

#endif //CMAKE_QEMU_TESTING_BLOG_QEMU_TESTING_DOCTEST_H
