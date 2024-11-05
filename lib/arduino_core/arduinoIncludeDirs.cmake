# Interface library for include directories
# This is packed into a separate file so it can be used by other projects

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