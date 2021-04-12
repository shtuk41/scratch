

print_hex:
	pusha

	mov bx, HEX_OUT
	add bx, 2

	mov ax, dx
	and ax, 0xf000
	shr ax, 12
	call print_hex_save

	mov ax, dx
	and ax, 0x0f00
	shr ax, 8
	call print_hex_save

	mov ax, dx
	and ax, 0x00f0
	shr ax, 4
	call print_hex_save

	mov ax, dx
	and ax, 0x000f
	call print_hex_save

	mov bx, HEX_OUT

	call print_string

	popa
	ret

print_hex_save:
	cmp ax, 0xa
	jl is_digit
	add ax, 87
	jmp is_digit_end
	is_digit:
		add ax, 48
	is_digit_end:

	mov [bx], ax
	add bx, 1
	ret

HEX_OUT: db '0x0000', 0