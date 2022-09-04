include(FetchContent)
include(CTest)

FetchContent_Declare(cmsis5_for_tests URL https://github.com/ARM-software/CMSIS_5/releases/download/5.9.0/ARM.CMSIS.5.9.0.pack)
FetchContent_Populate(cmsis5_for_tests)

find_program(QEMU_BIN_FOR_TEST qemu-system-arm
        REQUIRED
        DOC "qemu executable to run tests"
        HINTS "C:/Program\ Files/qemu")

message(STATUS "QEMU executable found: ${QEMU_BIN_FOR_TEST}")
set_property(SOURCE QemuArmTesting/qemu_testing_common.c
        APPEND_STRING
        PROPERTY COMPILE_FLAGS "-include \"${CMSIS_DEVICE_OPT}.h\"")

function(_add_qemu_test name )
    add_executable(${name} ${ARGN})
    set_property(TARGET ${name} PROPERTY SUFFIX .elf)

    target_compile_definitions(${name} PRIVATE ${CMSIS_DEVICE_OPT})

    target_include_directories(${name} PRIVATE
            ${cmsis5_for_tests_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Include
            ${cmsis5_for_tests_SOURCE_DIR}/CMSIS/Core/Include
            QemuArmTesting
            )

    target_sources(${name} PRIVATE
            QemuArmTesting/qemu_testing_common.c
            ${cmsis5_for_tests_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/startup_${CMSIS_DEVICE}.c
            ${cmsis5_for_tests_SOURCE_DIR}//Device/ARM/${CMSIS_DEVICE}/Source/system_${CMSIS_DEVICE}.c)
    target_compile_options(${name} PRIVATE -Os)
    target_link_options(${name} PRIVATE
            -T ${cmsis5_for_tests_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/GCC/gcc_arm.ld
            --specs=rdimon.specs --specs=nano.specs
            -Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${name}.map
            -Os
    )
    add_test(NAME ${name}
            COMMAND ${QEMU_BIN_FOR_TEST} -machine mps2-an500 -nographic --semihosting-config enable=on,target=native -icount shift=auto -kernel $<TARGET_FILE:${name}>)
endfunction()

function(add_qemu_test_doctest name )
    _add_qemu_test(${name} ${ARGN})
    target_sources(${name} PRIVATE
            QemuArmTesting/qemu_testing_doctest.h
            )
    target_compile_definitions(${name} PRIVATE
            DOCTEST_CONFIG_NO_EXCEPTIONS
            DOCTEST_CONFIG_NO_MULTITHREADING
            DOCTEST_CONFIG_NO_POSIX_SIGNALS
            DOCTEST_CONFIG_NO_WINDOWS_SEH
            DOCTEST_CONFIG_IMPLEMENT
            DOCTEST_CONFIG_COLORS_NONE
            )
    target_include_directories(${name} PRIVATE inc)
    target_compile_options(${name} PUBLIC -Wno-psabi)

endfunction()

function(add_qemu_test_generic name )
    _add_qemu_test(${name} ${ARGN})
    target_sources(${name} PRIVATE QemuArmTesting/qemu_testing.c)

endfunction()
