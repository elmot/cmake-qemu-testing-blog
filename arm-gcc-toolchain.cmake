find_program(CMAKE_C_COMPILER arm-none-eabi-gcc REQUIRED)
find_program(CMAKE_CXX_COMPILER arm-none-eabi-g++ REQUIRED)
find_program(CMAKE_ASM_COMPILER  arm-none-eabi-gcc REQUIRED)
find_program(CMAKE_AR arm-none-eabi-gcc-ar REQUIRED)
find_program(CMAKE_RANLIB arm-none-eabi-gcc-ranlib REQUIRED)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
