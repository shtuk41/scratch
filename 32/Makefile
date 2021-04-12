all: os-image
# Run bochs to simulate booting of our code .
run: all
	bochs
# This is the actual disk image that the computer loads ,
# which is the combination of our compiled bootsector and kernel
os-image: boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
kernel.bin: kernel_entry.o kernel.o
	#ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary -m elf_i386
	ld -o kernel.tmp -Ttext 0x1000 kernel_entry.o kernel.o -m elf_i386
	objcopy -O binary -j .text  kernel.tmp kernel.bin 
# Build our kernel object file .
kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@ -m32 -fno-pie
# Build our kernel entry object file .
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@ 
# Assemble the boot sector to raw machine code
# The -I options tells nasm where to find our useful assembly
# routines that we include in boot_sect . asm
boot_sect.bin: boot_sect.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin
# Clear away all generated files .
clean:
	rm -fr *.bin *.dis *.o os-image *.map
# Disassemble our kernel - might be useful for debugging .
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@	