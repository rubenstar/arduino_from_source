# Arduino Nano 33 IoT Embedded Software Repository

This repository provides a setup for building, compiling, linking, and flashing source code to the Arduino Nano 33 IoT. 
The example `main.cpp` is a simple blinky with a little test string that is output on the Serial-to-USB interface of the Arduino.


## Prerequisites

Ensure you have the following tools installed:
- [ARM GNU Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [CMake](https://cmake.org/download/) >= 3.29
- [GNU Make](https://www.gnu.org/software/make/)
- [OpenOCD](http://openocd.org/)
- A suitable SWD programmer. I used the [Raspberry Pi Debug Probe](https://www.raspberrypi.com/products/debug-probe/) but any compatible SWD programmer will work.

## Building

Clone the repository with submodules
```sh
git clone --recursive git@github.com:rubenstar/arduino_from_source.git
```

Build using cmake & make
```sh
mkdir build
cd build
cmake ..
make
```

## Flashing

To flash the binary, use OpenOCD with your SWD programmer. The following command will flash the compiled `main.elf`:

```sh
openocd -f interface/cmsis-dap.cfg -f target/at91samdXX.cfg -c "program main.elf reset verify exit"
```

## Supported Devices
This repository is currently tailored to the Arduino Nano 33 IoT which uses the SAMD21G18 chip. With a few minor changes you should be able to re-use this repo to support any Arduino though.

## Important Notes
1. The example program you flash will be compiled **without a bootloader**. Compiling with the bootloader is currently not supported.
2. If you need to restore the original bootloader, you can do so with the following command from the top-level directory:
    ```sh
    openocd -f interface/cmsis-dap.cfg -f target/at91samdXX.cfg -c "program lib/arduino_core/ArduinoCore-samd/bootloaders/nano_33_iot/samd21_sam_ba_arduino_nano_33_iot.bin verify exit 0x00000000"
    ```
3. I am using a custom linker script located at `lib/build_files/samd21g18a.ld`. It's more minimalistic than the ones that come with [ArduinoCore-samd](https://github.com/arduino/ArduinoCore-samd), and has some explanatory comments. You should be able to use linker scripts from the official repository too though, as long as they don't include the bootloader.
