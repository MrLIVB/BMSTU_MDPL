EXTRN output_even: near

SSEG SEGMENT Stack
	dw 256 dup(?)
SSEG ENDS

DSEG SEGMENT para public 'DATA'
	s1 db 20 Dup(?)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:SSEG
main:
	mov ax, DSEG
	mov ds, ax

	mov dl,0ah
    mov ah,2
    int 21h
	
	xor ax, ax
	mov ah,0ah
    lea dx, s1
    int 21h
    
    mov dl,0ah
    mov ah,2
    int 21h

	call output_even
	
	mov dl,0ah
    mov ah,2
    int 21h
	
	xor ax, ax
	mov ax, 4c00h
	int 21h
CSEG ENDS
PUBLIC s1
END main