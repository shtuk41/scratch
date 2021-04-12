disk_load:
	push dx			; 	Store DX on stack so later we can 
					;	recall how many sectors were requested to be read


	mov ah, 0x02	;	BIOS read sector function
	mov cl, dh		; 	read DH sectors
	mov ch, 0x00	;	select cylynder 0
	mov dh, 0x00	;	select head 0
	mov cl, 0x02	;	start reading from second secotr
					;	i.e. after the boot sector
	int 0x13		;	BIOS interrupt

	jc disk_error	; 	jump if error, carry flag set
	pop DX  		;   restore dx from the stack
	cmp dh, al		;	if AL (sector read) != DH (sectors expected)
	jne disk_error	;	display error message
	ret

disk_error:
	mov bx, DISK_ERROR_MSG_1
	call print_string
	jmp $

disk_error_2:
	mov bx, DISK_ERROR_MSG_2
	call print_string
	jmp $


DISK_ERROR_MSG_1 db "Disk read error 1!", 0
DISK_ERROR_MSG_2 db "Disk read error 2!", 0