[bits 16]

; boot sector that enters 32-bit protected mode
[org 0x7c00]

KERNEL_OFFSET equ 0x1000 ; THis is the memory offset to which we will load our kernel

mov [BOOT_DRIVE], dl 		; BIOS stores our boot drive in DL, so it's
							; best to remember this for later

mov bp, 0x9000	;set the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call load_kernel 			; load kernel

call switch_to_pm

mov bx, MSG_REAL_MODE_STILL
call print_string

jmp $

%include "print_string.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET	;setup parameters for our disk_load routine
	mov dh, 15				;so that we load the first 15 sectors (excluding)
	mov dl, [BOOT_DRIVE]	; the boot sector) from the boot disk (i.e our)
	call disk_load			;kernel code) to address KERNEL_OFFSET

	ret

[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE

	call print_string_pm 	; user 32-bit print routine

	call KERNEL_OFFSET		; Now jump to the address of our loaded kernel code

	

	jmp $

; Global variables
BOOT_DRIVE 			db 0
MSG_REAL_MODE 		db "Started in 16-bit Real mode", 0
MSG_REAL_MODE_STILL db "Still in 16-bit Real mode", 0
MSG_PROT_MODE 		db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL		db "Loading kernel into memory.", 0

;Bootsector padding

times 510 - ($-$$) db 0
dw 0xaa55
