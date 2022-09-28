include(FetchContent)
include(CTest)

FetchContent_Declare(cmsis5 URL https://github.com/ARM-software/CMSIS_5/releases/download/5.9.0/ARM.CMSIS.5.9.0.pack)
FetchContent_Populate(cmsis5)

find_program(QEMU_BIN_FOR_TEST qemu-system-arm
        REQUIRED
        DOC "qemu executable to run tests"
        HINTS "C:/Program\ Files/qemu")

message(STATUS "QEMU executable found: ${QEMU_BIN_FOR_TEST}")
set_property(SOURCE qemu_testing/qemu_testing.c APPEND_STRING PROPERTY COMPILE_FLAGS "-include \"${CMSIS_DEVICE_OPT}.h\"")


function(add_qemu_test name )
    add_executable(${name} ${ARGN})
    set_property(TARGET ${name} PROPERTY SUFFIX .elf)

    target_compile_definitions(${name} PRIVATE ${CMSIS_DEVICE_OPT})

    target_include_directories(${name} PRIVATE
            ${cmsis5_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Include
            ${cmsis5_SOURCE_DIR}/CMSIS/Core/Include
            qemu_testing
            )

    target_sources(${name} PRIVATE
            qemu_testing/qemu_testing.c
            ${cmsis5_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/startup_${CMSIS_DEVICE}.c
            ${cmsis5_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/system_${CMSIS_DEVICE}.c)
    target_link_options(${name} PRIVATE
            -T ${cmsis5_SOURCE_DIR}/Device/ARM/${CMSIS_DEVICE}/Source/GCC/gcc_arm.ld
            --specs=rdimon.specs --specs=nano.specs
            -Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${name}.map
    )
    add_test(NAME ${name}
            COMMAND ${QEMU_BIN_FOR_TEST} -machine musca-b1 -nographic --semihosting-config enable=on,target=native -icount shift=auto -kernel $<TARGET_FILE:${name}>)
endfunction()





