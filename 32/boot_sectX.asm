	BITS 16
;[org 0x7c00]

mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine

mov al, the_secret
int 0x10

mov al, [the_secret]
int 0x10

mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10

mov al, [0x7c1d]
int 0x10

loop:
	jmp loop

the_secret:
	db "X"


times 510 - ($ - $$) db 0

dw 0xaa55