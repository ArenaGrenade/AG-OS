# Compile all the required files
i686-elf-gcc -std=gnu99 -ffreestanding -g -c start.s -o start.o
i686-elf-gcc -std=gnu99 -ffreestanding -g -c kernel.c -o kernel.o

# Link the files into a final executable
i686-elf-gcc -ffreestanding -nostdlib -g -T linker.ld start.o kernel.o -o agos.elf -lgcc

# Run the kernel
qemu-system-i386 -machine type=pc-i440fx-3.1 -kernel agos.elf
