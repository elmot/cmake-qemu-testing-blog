cmake_minimum_required(VERSION 3.23)
project(cmake_qemu_testing_blog C CXX ASM)

include(cmake/cmsis.cmake)
set(CMAKE_C_STANDARD 17)

#####################
#  CPU type         #
#####################
# CMSIS device name, ex. ARMCM35P or ARMCM7
set(CMSIS_DEVICE ARMCM33)
# CMSIS device name, ex. ARMCM35P or ARMCM7_DP
set(CMSIS_DEVICE_OPT ${CMSIS_DEVICE}_DSP_FP)
# GCC mcpu name, ex. cortex-m0plus
set(GCC_MCPU cortex-m33)
# GCC floating-point settings, ex. '-mfloat-abi=hard;-mfpu=fpv4-sp-d16'")
set(GCC_FP_SWITCHES -mfloat-abi=hard;-mfpu=fpv4-sp-d16)
#####################
#  End of CPU type  #
#####################

add_compile_options(${GCC_FP_SWITCHES})
add_link_options(${GCC_FP_SWITCHES})

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    message(STATUS "Maximum optimization for speed")
    add_compile_options(-Ofast)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    message(STATUS "Maximum optimization for speed, debug info included")
    add_compile_options(-Ofast -g)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    message(STATUS "Maximum optimization for size")
    add_compile_options(-Os)
else ()
    message(STATUS "Minimal optimization, debug info included")
    add_compile_options(-Og -g3)
endif ()

add_compile_options(-mcpu=${GCC_MCPU})
add_compile_options(-ffunction-sections -fdata-sections -fno-common -fmessage-length=0)
add_link_options(-mcpu=${GCC_MCPU})

add_link_options(-Wl,-u,_printf_float)

add_executable(test_firmware main.c)

target_compile_definitions(test_firmware PRIVATE ${CMSIS_DEVICE_OPT})
set_property(SOURCE main.c APPEND_STRING PROPERTY COMPILE_FLAGS "-include \"${CMSIS_DEVICE_OPT}.h\"")
target_include_directories(test_firmware PRIVATE
        ${PROJECT_SOURCE_DIR}/CMSIS/Device/ARM/${CMSIS_DEVICE}/Include
        ${PROJECT_SOURCE_DIR}/CMSIS/CMSIS/Core/Include
        )
set_property(TARGET test_firmware PROPERTY SUFFIX .elf)

target_sources(test_firmware PRIVATE
        ${PROJECT_SOURCE_DIR}/CMSIS/Device/ARM/${CMSIS_DEVICE}/Source/startup_${CMSIS_DEVICE}.c
        ${PROJECT_SOURCE_DIR}/CMSIS/Device/ARM/${CMSIS_DEVICE}/Source/system_${CMSIS_DEVICE}.c)
target_link_options(test_firmware PRIVATE --specs=rdimon.specs --specs=nano.specs)
target_link_options(test_firmware PRIVATE -Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map)
target_link_options(test_firmware PRIVATE -T ${PROJECT_SOURCE_DIR}/CMSIS/Device/ARM/${CMSIS_DEVICE}/Source/GCC/gcc_arm.ld)
