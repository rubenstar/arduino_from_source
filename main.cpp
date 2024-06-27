#include "Arduino.h"

extern USBDeviceClass USBDevice;
extern "C" void __libc_init_array(void);

int main()
{
    init();
    initVariant();

    // I provide my own copy of __libc_init_array() in libc_init.c
    // This calls constructors in variant.cpp (All SERCOM stuff)
    __libc_init_array();

    USBDevice.init();
    USBDevice.attach();

    pinMode(LED_BUILTIN, OUTPUT);
    Serial.begin(115200);
    uint8_t i = 0;

    while (1)
    {
        digitalWrite(LED_BUILTIN, HIGH);
        delay(1000);
        digitalWrite(LED_BUILTIN, LOW);
        delay(1000);

        Serial.print(F("Hello world: "));
        Serial.println(i++);
    }
    return 0;
}