	BITS 16

[org 0x7c00]

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000	;	load 5 sectors to 0x0000 (ES) : 0x9000 (BX)
mov dh, 5   	;	from the boot disk

mov dl, [BOOT_DRIVE]
call disk_load

mov dx, [0x9000]	; print out the first loaded word, which
call print_hex 		; we execpt to be 0xdada stored at adress 0x9000

mov dx, [0x9000 + 512] ; also, print the first word from the 2nd loaded sector should be 0xface

call print_hex


mov ah, 0x0e
mov al, 0xA
int 0x10

mov bx, BOOTING_OS_MSG
call print_string

call insert_newline_cr

mov bx, GOODBYE_OS_MSG
call print_string

call insert_newline_cr

mov dx, 0x1fb6
call print_hex

loop:
	jmp loop

%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"


BOOTING_OS_MSG:
	db 'Booting OS', 0


GOODBYE_OS_MSG:
	db 'Goodbye OS', 0

BOOT_DRIVE: db 0

times 510 - ($ - $$) db 0

dw 0xaa55	

times 256 dw 0xdada
times 256 dw 0xface

