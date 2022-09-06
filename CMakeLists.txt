cmake_minimum_required(VERSION 3.23)

include(arm-gcc-toolchain.cmake) # Must be included before 'project' clause

project(cmake_qemu_testing_blog C CXX ASM)

set(CMAKE_C_STANDARD 17)

######################################
#  CPU type settings                 #
######################################
# CMSIS device name, ex. ARMCM35P or ARMCM7
set(CMSIS_DEVICE ARMCM33)
# CMSIS device name, ex. ARMCM35P or ARMCM7_DP
set(CMSIS_DEVICE_OPT ${CMSIS_DEVICE}_DSP_FP)
# GCC mcpu name, ex. cortex-m0plus
set(GCC_MCPU cortex-m33)
# GCC floating-point settings, ex. '-mfloat-abi=hard;-mfpu=fpv4-sp-d16'")
set(GCC_FP_SWITCHES -mfloat-abi=hard;-mfpu=fpv4-sp-d16)
######################################
#  End of CPU type                   #
######################################

#  Project-wide CPU-related compiler settings
add_compile_options(-mcpu=${GCC_MCPU} ${GCC_FP_SWITCHES})
add_link_options(-mcpu=${GCC_MCPU} ${GCC_FP_SWITCHES})
#  Generic compiler settings for an embedded project
add_compile_options(-ffunction-sections -fdata-sections -fno-common -fmessage-length=0)
add_link_options(-Wl,-gc-sections)
# Enables support float format %f in printf
add_link_options(-Wl,-u,_printf_float)

#  Project-wide debug info and optimization settings
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    message(STATUS "Maximum optimization for speed")
    add_compile_options(-Ofast -flto)
    add_link_options(-Ofast -flto)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    message(STATUS "Maximum optimization for speed, debug info included")
    add_compile_options(-Ofast -g)
    add_link_options(-Ofast -flto)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    message(STATUS "Maximum optimization for size")
    add_compile_options(-Os)
    add_link_options(-Os)
else ()
    message(STATUS "Minimal optimization, debug info included")
    add_compile_options(-Og -g3)
    add_link_options(-Og -g3)
endif ()

# Include testing-related code
include(qemu_testing/qemu_testing.cmake)

# A subset of CMSIS-DSP,
# 32-bit Floating-point FIR(Finite impulse response) filter processing function
add_library(CMSIS_DSP_FIR_F32 INTERFACE
        ${cmsis5_SOURCE_DIR}/CMSIS/DSP/Source/FilteringFunctions/arm_fir_f32.c
        ${cmsis5_SOURCE_DIR}/CMSIS/DSP/Source/FilteringFunctions/arm_fir_init_f32.c
        )
target_include_directories(CMSIS_DSP_FIR_F32 INTERFACE ${cmsis5_SOURCE_DIR}/CMSIS/DSP/Include)
target_link_libraries(CMSIS_DSP_FIR_F32 INTERFACE m)

######################################
#  FIR test                          #
#  Borrowed from CMSIS-DAP examples  #
######################################
add_qemu_test(factorial_test test/factorial-test.c)
add_qemu_test(fir_test
        test/arm-dsp/arm_fir_data.c
        test/arm-dsp/arm_fir_test_f32.c
        test/arm-dsp/math_helper.c
        $<TARGET_PROPERTY:CMSIS_DSP_FIR_F32,SOURCES>
        )
target_link_libraries(fir_test CMSIS_DSP_FIR_F32)

######################################
#  Stack overflow test               #
######################################
add_qemu_test(stack_corrupted_test test/stack_corrupted_test.c)
target_compile_options(stack_corrupted_test PRIVATE -fstack-protector-all)
