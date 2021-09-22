#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
    #error "We are not using a cross-compiler."
#elif !defined(__i386__)
    #error "We are not using the x86-elf compiler."
#endif

// x86 VGA buffer defined as volatile as we only have a pointer to those memory locations
volatile uint16_t* vga_buffer = (uint16_t*) 0xB8000;
// Default VGA textmode buffer sizes
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

// Our screen pointers, for placing the cursor at that location
int term_col = 0;
int term_row = 0;

// Color handling works
// Entries in the VGA buffer take the binary form BBBBFFFFCCCCCCCC
// as B - background, F - foreground, C - ascii character
uint8_t term_color = 0x0F;

void cls() {
    for (int col = 0; col < VGA_COLS; col++) {
        for (int row = 0; row < VGA_ROWS; row++) {
            const size_t char_idx = (VGA_COLS * row) + col;
            vga_buffer[char_idx] = ((uint16_t) term_color << 8) | ' ';
        }
    }
}

void putc(char c) {
    switch (c) {
        case '\n': {
            term_col = 0;
            term_row++;
            break;
        } default: {
            const size_t char_idx = (VGA_COLS * term_row) + term_col;
            vga_buffer[char_idx] = ((uint16_t) term_color << 8) | c;
            term_col++;
            break;
        }
    }
    if (term_col >= VGA_COLS) {
        term_col = 0;
        term_row++;
    }
    if (term_row >= VGA_ROWS) {
        term_col = 0;
        term_row = 0;
    }
}

void print(const char* str) {
    for (size_t i = 0; str[i] != '\0'; i++) {
        putc(str[i]);
    }
}

void kernel_main() {
    cls();
    print("Hi!\n");
    print("Welcome to AG OS.\n");
}