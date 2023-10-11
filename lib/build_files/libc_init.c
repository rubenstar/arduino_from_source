// This is my own copy of the libc_init_array function. I use this, as Newlib that comes with
// arm gnu gcc does not compile this function with debug information. This causes the debugger
// to jumble up some symbols, making debugging harder. 

// Explanation what this function does can be found here: 
// https://interrupt.memfault.com/blog/boostrapping-libc-with-newlib

// Sourcecode:
// https://github.com/bminor/newlib/blob/master/newlib/libc/misc/init.c

#include <stddef.h>

/* These magic symbols are provided by the linker.  */
extern void (*__preinit_array_start []) (void) __attribute__((weak));
extern void (*__preinit_array_end []) (void) __attribute__((weak));
extern void (*__init_array_start []) (void) __attribute__((weak));
extern void (*__init_array_end []) (void) __attribute__((weak));

/* Iterate over all the init routines.  */
void __libc_init_array (void)
{
  size_t count;
  size_t i;

  count = __preinit_array_end - __preinit_array_start;
  for (i = 0; i < count; i++)
    __preinit_array_start[i] ();

  count = __init_array_end - __init_array_start;
  for (i = 0; i < count; i++)
    __init_array_start[i] ();
}