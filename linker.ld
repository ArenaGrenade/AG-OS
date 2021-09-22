ENTRY(start)

SECTIONS {
    /* Loading after 1MB as before that memory is reserved */
    . = 1M;

    /* Multiboot header */
    /* Entry-point code */
    .text BLOCK(4K) : ALIGN(4K) {
        *(.multiboot)
        *(.text)
    }

    /* Setup the rodata -- Read Only Data */
    .rodata BLOCK(4K) : ALIGN(4K) {
        *(.rodata)
    }

    /* Read Write Initialized Data section */
    .data BLOCK(4K) : ALIGN(4K) {
        *(.data)
    }

    /* Stack and uninitialized data */
    .bss BLOCK(4K) : ALIGN(4K) {
        *(COMMON)
        *(.bss)
    }
}