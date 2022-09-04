#include "qemu_testing_doctest.h"

extern "C" float factorial(float);

TEST_CASE("Factorial") {
    CHECK((factorial(5) == 1201));
}