cmake_minimum_required(VERSION 3.29)

set(ARDUINO_FROM_SOURCE_DIR ${CMAKE_SOURCE_DIR})

# toolchain file before project() command: https://stackoverflow.com/a/63944545
include(${CMAKE_SOURCE_DIR}/lib/build_files/toolchain.cmake)

project(arduino_from_source)

add_compile_definitions(__SAMD21G18A__)
add_compile_definitions(USBCON)

add_subdirectory(${ARDUINO_FROM_SOURCE_DIR}/lib/arduino_core)
add_subdirectory(${ARDUINO_FROM_SOURCE_DIR}/lib/build_files)

add_executable(main.elf main.cpp)
target_link_libraries(main.elf arduinoLib myBuildLib)
target_compile_options(main.elf PRIVATE ${COMPILE_FLAGS})
target_link_options(main.elf PRIVATE ${LINK_FLAGS})