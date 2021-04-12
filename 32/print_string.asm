

print_string:
pusha
	mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine
	
print_string_next:	
	
	mov al, [bx]

	cmp al, 0
	je print_string_end

	
	int 0x10

	add bx,1 
	jmp print_string_next

print_string_end:
	popa
	ret


insert_newline_cr:
	pusha

	mov ah, 0x0e
	mov al, 0xA
	int 0x10

	mov ah, 0x0e
	mov al, 0xD
	int 0x10

	popa
	ret

