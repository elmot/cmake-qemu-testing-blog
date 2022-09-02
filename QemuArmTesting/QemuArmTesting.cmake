include(FetchContent)
include(CTest)

FetchContent_Declare(cmsis5_for_tests URL https://github.com/ARM-software/CMSIS_5/releases/download/5.9.0/ARM.CMSIS.5.9.0.pack)
FetchContent_Populate(cmsis5_for_tests)

find_program(QEMU_BIN_FOR_TEST qemu-system-arm
        REQUIRED
        DOC "qemu executable to run tests"
        HINTS "C:/Program\ Files/qemu")

message(STATUS "QEMU executable found: ${QEMU_BIN_FOR_TEST}")
set_property(SOURCE QemuArmTesting/testing_main.c APPEND_STRING PROPERTY COMPILE_FLAGS "-include \"${CMSIS_DEVICE_OPT}.h\"")


function(add_qemu_test name )
    add_executable(${name} ${ARGN})
    set_property(TARGET ${name} PROPERTY SUFFIX .elf)

    target_compile_definitions(${name} PRIVATE ${CMSIS_DEVICE_OPT})

    target_include_directories(${name} PRIVATE
            ${cmsis5_for_tests_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Include
            ${cmsis5_for_tests_SOURCE_DIR}/CMSIS/Core/Include
            QemuArmTesting
            )

    target_sources(${name} PRIVATE
            QemuArmTesting/testing_main.c
            ${cmsis5_for_tests_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/startup_${CMSIS_DEVICE}.c
            ${cmsis5_for_tests_SOURCE_DIR}//Device/ARM/${CMSIS_DEVICE}/Source/system_${CMSIS_DEVICE}.c)
    target_link_options(${name} PRIVATE
            -T ${cmsis5_for_tests_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/GCC/gcc_arm.ld
            --specs=rdimon.specs --specs=nano.specs
            -Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${name}.map
    )
    add_test(NAME ${name}
            COMMAND ${QEMU_BIN_FOR_TEST} -machine mps2-an500 -nographic --semihosting-config enable=on,target=native -icount shift=auto -kernel $<TARGET_FILE:${name}>)
endfunction()





