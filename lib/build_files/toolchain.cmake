# Set cross compilation information
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Skip cmake compiler checks as they fail due to cross compilation 
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Set toolchain
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

set(CPU cortex-m0plus) # Cortex-M0+
set(FLOAT soft)        # SAMD21G18A does not have a FPU
set(ARM_ISA mthumb)    # Cortex-M0+ is Thumb only

set(OPTIMISATION "-O0")
set(DEBUG "-ggdb")

# Compilation flags (https://gcc.gnu.org/onlinedocs/gcc-14.1.0/gcc.pdf)
set(COMPILE_FLAGS 
    -${ARM_ISA};
    -mcpu=${CPU};
    -mfloat-abi=${FLOAT};
    ${OPTIMISATION};
    ${DEBUG};
    -Wall;                  # Enable all warnings
#    -pedantic;             # Enable pedantic warnings
    -MD;                    # Generate dependency output file (a xxx.obj.d file for every xxx.obj file)
    -ffunction-sections;    # Place each function in its own section (e.g. foo() will be put into .text.foo)
    -fdata-sections;        # Place each data in its own section
)

# "-Wl,option" passes the option to the linker
set(LINK_FLAGS 
    -T${ARDUINO_FROM_SOURCE_DIR}/lib/build_files/samd21g18a.ld;
    #-T${ARDUINO_FROM_SOURCE_DIR}/lib/arduino_core/ArduinoCore-samd/variants/nano_33_iot/linker_scripts/gcc/flash_without_bootloader.ld;
    -Wl,-Map=output.map;   # Generate a map file
    -Wl,--gc-sections;     # Garbage collect unused sections; good in combination with -ffunction-sections
    --specs=nosys.specs;   # https://stackoverflow.com/questions/43781207/how-to-cross-compile-with-cmake-arm-none-eabi-on-windows
    -mcpu=${CPU};          # This is needed for linker to know which version of the standard library to link against
)

# Remove annoying linker warnings (https://stackoverflow.com/a/75288268/1792524)