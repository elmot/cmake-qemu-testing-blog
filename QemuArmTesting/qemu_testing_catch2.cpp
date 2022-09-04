#include <iostream>
#include "catch_amalgamated.hpp"
extern "C" void qemu_testing_setup(void);
extern "C" void qemu_testing_teardown(void);

int main( int argc, char* argv[] ) {
    qemu_testing_setup();
    Catch::Session session;
    session.configData().defaultColourMode = Catch::ColourMode::None;
    session.configData().noThrow = true;
    session.configData().processName = "--";
    session.configData().name = "embedded catch2";
    int result = session.run(argc, argv );

    qemu_testing_teardown();
    exit(result);
}

std::ostream& Catch::cout() { return std::cout; }
std::ostream& Catch::cerr() { return std::cout; }
std::ostream& Catch::clog() { return std::cout; }
