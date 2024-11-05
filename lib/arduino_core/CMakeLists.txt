# ARM SAMD21 family
set (SAMD_DIR ${ARDUINO_FROM_SOURCE_DIR}/lib/arduino_core/ArduinoCore-samd)
# ARM CMSIS
set (ARM_CMSIS_DIR ${ARDUINO_FROM_SOURCE_DIR}/lib/arduino_core/CMSIS_5)
set (ARDUINO_CMSIS_DIR ${ARDUINO_FROM_SOURCE_DIR}/lib/arduino_core/ArduinoModule-CMSIS-Atmel/CMSIS-Atmel/CMSIS/Device/ATMEL)
# ARDUINO API
set (ARDUINO_API_DIR ${ARDUINO_FROM_SOURCE_DIR}/lib/arduino_core/ArduinoCore-API)

add_compile_definitions(CRYSTALLESS)

# USB build flags from ArduinoCore-samd (boards.txt)
add_compile_definitions(USB_VID=0x2341)
add_compile_definitions(USB_PID=0x8057)
add_compile_definitions(USB_MANUFACTURER="Arduino LLC")
add_compile_definitions(USB_PRODUCT="Arduino NANO 33 IoT")

# Misc build flags
add_compile_definitions(F_CPU=48000000L)

# Interface library for include directories
add_library(arduinoIncludeDirs INTERFACE)
target_include_directories(arduinoIncludeDirs INTERFACE
    ${ARDUINO_CMSIS_DIR}/                       # samd.h 
    ${ARDUINO_CMSIS_DIR}/samd21/include         # samd21xxx.h 
    ${SAMD_DIR}/libraries/SPI                   # SPI.h
    ${SAMD_DIR}/variants/nano_33_iot            # variant.h
    ${SAMD_DIR}/cores/arduino                   # arduino.h / WVariant.h
    ${SAMD_DIR}/cores/arduino/USB               # All USB related headers
    ${ARM_CMSIS_DIR}/CMSIS/Core/Include         # only for core_cm0plus.h
    ${ARDUINO_API_DIR}/                         # A variety of API headers, mainly ArduinoAPI.h, needed by SAMD lib
)

# CORTEX-M0+ build library
add_library(arduinoLib
    ${SAMD_DIR}/cores/arduino/cortex_handlers.c   # Vector table defined here
    ${SAMD_DIR}/cores/arduino/startup.c           # Chip configuration at startup
    ${SAMD_DIR}/cores/arduino/wiring.c            # Arduino board initialization (init())
    ${SAMD_DIR}/cores/arduino/wiring_digital.c    # Digital pin manipulation
    ${SAMD_DIR}/cores/arduino/wiring_analog.c     # Analog pin manipulation
    ${SAMD_DIR}/cores/arduino/wiring_private.c    # Definition of private pinPeripheral method
    ${SAMD_DIR}/cores/arduino/hooks.c             # sysTick and pendSV handlers
    ${SAMD_DIR}/cores/arduino/delay.c             # As the library name says, but also SysTick Handler
    ${SAMD_DIR}/cores/arduino/Reset.cpp           # Some reset handler stuff needed by SysTick-handler
    ${SAMD_DIR}/cores/arduino/Uart.cpp            # UART functionality
    ${SAMD_DIR}/cores/arduino/SERCOM.cpp          # Serial communication functionality
    ${SAMD_DIR}/cores/arduino/USB/CDC.cpp         # Serial/USB related stuff
    ${SAMD_DIR}/cores/arduino/USB/USBCore.cpp     # Serial/USB related stuff
    ${SAMD_DIR}/variants/nano_33_iot/variant.cpp  # Nano33 pin description
    ${SAMD_DIR}/libraries/Wire/Wire.cpp           # I think thats I2C
    ${SAMD_DIR}/libraries/SPI/SPI.cpp             # I think thats SPI
    ${ARDUINO_API_DIR}/api/PluggableUSB.cpp       # As the name says
    ${ARDUINO_API_DIR}/api/Print.cpp              # Standard print methods
    ${ARDUINO_API_DIR}/api/String.cpp
)

target_link_libraries(arduinoLib PUBLIC arduinoIncludeDirs)

target_compile_options(arduinoLib PRIVATE ${COMPILE_FLAGS})