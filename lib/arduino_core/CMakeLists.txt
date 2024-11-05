add_compile_definitions(CRYSTALLESS)

# USB build flags from ArduinoCore-samd (boards.txt)
add_compile_definitions(USB_VID=0x2341)
add_compile_definitions(USB_PID=0x8057)
add_compile_definitions(USB_MANUFACTURER="Arduino LLC")
add_compile_definitions(USB_PRODUCT="Arduino NANO 33 IoT")

# Misc build flags
add_compile_definitions(F_CPU=48000000L)

include(arduinoIncludeDirs.cmake)

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