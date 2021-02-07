PUBLIC output_even
EXTRN s1: byte

DSEG SEGMENT PARA PUBLIC 'DATA'
	db 100 dup(?)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
output_even proc near

	xor di, di
	mov cx, 5
	mov ah, 2h	
output:	
	add di, 2
	mov dl,[s1+1+di]
    int 21h
	loop output	
	ret
output_even endp
CSEG ENDS
END