#include "catch_amalgamated.hpp"

extern "C" float factorial(float);

TEST_CASE("Factorial","25") {
    CHECK(factorial(5) == 121);
}