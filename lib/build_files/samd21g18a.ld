/* https://blog.thea.codes/the-most-thoroughly-commented-linker-script/ */

FLASH_SIZE = 0x40000;   /* 256kB */
SRAM_SIZE = 0x8000;     /* 32kB */
NVM_SIZE = 0x400;       /* 1kB */

STACK_SIZE = 0x800;     /* 2kB */
HEAP_SIZE = 0x800;      /* 2kB */

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = FLASH_SIZE - NVM_SIZE
    NVM (r)    : ORIGIN = FLASH_SIZE - NVM_SIZE, LENGTH = NVM_SIZE
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = SRAM_SIZE
}

/* Its not yet entirely clear to me under which circumstances I 
need this ENTRY(...) statement. Without it, the resulting main.elf is 
empty */
ENTRY(Reset_Handler)

SECTIONS
{

    /* Needed by reset.cpp. Somehow the reset handler would erase NVM if this is set sufficiently high */    
	__text_start__ = .;

    .isr_vector :
    {
        /* ._sfixed = .; /* This is used by startup code to determine where the VectorTable is. It can actually have an offset, so I could put something
        before it here. */
        /* The KEEP statement is used to prevent the linker from discarding the section if it is not referenced elsewhere in the code */
        /* This is particularly necessary for the vectors section, as it is not referenced in the code, but will reference everything else */
        KEEP(*(.isr_vector)) /* "*" is a wildcard character which matches any file -> any ".vectors" section in any file */
        . = ALIGN(4); /* Align location counter to 4 (ARM ELF format requires it) */
    } > FLASH

    .text :
    {
        . = ALIGN(4);
        *(.text*)   /* Contains all executable instructions, e.g. functions */

        /* C++ constructors / desctuctors */
		KEEP(*(.init))
		KEEP(*(.fini))

        *(.rodata*) /* Holds all global and static variables that are read only (const) */
        . = ALIGN(4);
    } > FLASH

    /* This is a table for stack unwinding for the ARM
    exception handling routines. This is a process where the 
    stack is "unwinded" and traversed back from the point of an exception
    to a handler that can actually handle it. More research good. */
	__exidx_start = .;
	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} > FLASH
	__exidx_end = .;

    __etext = .; /* Symbol marking end of text section */

    /* Place stack to the beginning of RAM (lowest address)*/
    /* As ARM stack grows downwards, an overflow will trigger a hard fault, as stack grows below its limit */
    .stack :
    {
        __StackBottom = .;
        . = . + STACK_SIZE;
        . = ALIGN(4);
        __StackTop = .;
    } > SRAM

    /* .data section contains initialized global and static variables */
    /* Values are stored in .text, and are copied from FLASH to SRAM during startup */
    .data : AT (__etext) /* Move data just behind .text in FLASH (LMA Load Memory Adress), but relocation address (VMA Virtual Memory Address) is in SRAM */
    {
        __data_start__ = .;
        *(.data*)
        . = ALIGN(4);

		/* preinit data */
		PROVIDE_HIDDEN (__preinit_array_start = .);
		KEEP(*(.preinit_array))
		PROVIDE_HIDDEN (__preinit_array_end = .);

		. = ALIGN(4);
		/* init data */
		PROVIDE_HIDDEN (__init_array_start = .);
		KEEP(*(SORT(.init_array.*)))
		KEEP(*(.init_array))
		PROVIDE_HIDDEN (__init_array_end = .);

		. = ALIGN(4);
		/* finit data */
		PROVIDE_HIDDEN (__fini_array_start = .);
		KEEP(*(SORT(.fini_array.*)))
		KEEP(*(.fini_array))
		PROVIDE_HIDDEN (__fini_array_end = .);

        __data_end__ = .;
    } > SRAM

    /* .bss section contains uninitialized global and static variables */
    /* They will be zeroed out by the startup code */
    .bss :
    {
        __bss_start__ = .;
        *(.bss*) /* On newer GCC, a zero initialized variable int i = 0; will go directly there */ 
        *(COMMON) /* An unitilialized variable int i; will go to .common first. It is allowed to have multiple unitialized definitions of a variable 
        amongst different files, so called "tentiative definitions". Its not encouraged, though. Best practice is to then move .common into .bss,
        so we adher to the C/C++ standard of zero intializing all uninitialized global and static variables.*/
        . = ALIGN(4);
        __bss_end__ = .;
    } > SRAM
    
    .heap :
    {
        __heap_start__ = .;
        /* end is used by _sbrk syscall function supplied by libnosys.a */
		PROVIDE(end = .);
        . = . + HEAP_SIZE;
        . = ALIGN(4);
        __heap_end__ = .;
    } > SRAM

}