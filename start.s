// Assembly file that initializes the kernel

// Want to use the main function from our C code so its
// defined external here.
.extern kernel_main

// Defining the start of code label in this file to be global
// so that the linker can access it
.global start

// GRUB Multiboot header constants
.set MB_MAGIC, 0x1BADB002
.set MB_FLAGS, (1 << 0) | (1 << 1)
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))

// Multiboot header section
.section .multiboot
    .align 4
    .long MB_MAGIC
    .long MB_FLAGS
    .long MB_CHECKSUM

// Data Initialization
.section .bss
    .align 16
    stack_bottom:
        .skip 4096
    stack_top:

// Kernel load code
.section .text
    // This is the entry point called earlier
    start:
        // C runnable environment just needs a stack.
        // So setting that up
        mov $stack_top, %esp // Stack pointer to top of stack

        // Calling the C main function
        call kernel_main

        // The C function should not return. And if it does we stop running the PC
        hang:
            cli         // Stop CPU interrupts
            hlt         // Halt the CPU
            jmp hang    // Try again if the above commands didnt work
