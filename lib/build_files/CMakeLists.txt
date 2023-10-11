set (BUILDFILES_DIR ${ARDUINO_FROM_SOURCE_DIR}/lib/build_files)

add_library(myBuildLib
    ${BUILDFILES_DIR}/libc_init.c   # __libc_init_array() copy for debugging purposes
)

target_compile_options(myBuildLib PRIVATE ${COMPILE_FLAGS})