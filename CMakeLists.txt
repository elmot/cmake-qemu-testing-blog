cmake_minimum_required(VERSION 3.23)

include(arm-gcc-toolchain.cmake) # Must be included before 'project' clause

project(cmake_qemu_testing_blog C CXX ASM)

set(CMAKE_C_STANDARD 17)

#####################
#  CPU type         #
#####################
# CMSIS device name, ex. ARMCM35P or ARMCM7
set(CMSIS_DEVICE ARMCM7)
# CMSIS device name, ex. ARMCM35P or ARMCM7_DP
set(CMSIS_DEVICE_OPT ${CMSIS_DEVICE}_SP)
# GCC mcpu name, ex. cortex-m0plus
set(GCC_MCPU cortex-m7)
# GCC floating-point settings, ex. '-mfloat-abi=hard;-mfpu=fpv4-sp-d16'")
set(GCC_FP_SWITCHES -mfloat-abi=hard;-mfpu=fpv4-sp-d16)
#####################
#  End of CPU type  #
#####################

add_compile_options(-mcpu=${GCC_MCPU} ${GCC_FP_SWITCHES})
add_compile_options(-ffunction-sections -fdata-sections -fno-common -fmessage-length=0)
add_link_options(-mcpu=${GCC_MCPU} ${GCC_FP_SWITCHES} -Wl,-gc-sections)

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

include(QemuArmTesting/QemuArmTesting.cmake)

Include(FetchContent)

include(CTest)

add_qemu_test_generic(factorial_test src/factorial.c test/factorial-test.c)
target_link_options( factorial_test PRIVATE -Wl,-u,_printf_float)
add_qemu_test_doctest(factorial_test_doctest src/factorial.c test/factorial-test.cpp)
