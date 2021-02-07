.model tiny
.code
.186
org 100h
start proc near
    mov ax, 351Ch
    int 21h

    mov word ptr old_int1Ch, bx
    mov word ptr old_int1Ch+2, es

    ;mov ax, 251Ch
    ;mov dx, offset int1Ch_handler
    ;int 21h

    call int1Ch_handler

    mov ah, 1
    int 21h

    mov ax, 251Ch
    mov dx, word ptr old_int1Ch+2
    mov ds, dx
    mov dx, word ptr cs:old_int1Ch
    int 21h

    ret
old_int1Ch dd ?
start_position dw 50*0 + 75*2
start endp

int1Ch_handler proc far
    pusha
    push es
    push ds

    push cs
    pop ds
    
    mov ah, 02h
    int 1Ah
    jc exit_handler
    
    mov al, ch
    call bcd2asc
    mov byte ptr output_line[2], ah
    mov byte ptr output_line[4], al

    mov al, cl
    call bcd2asc
    mov byte ptr output_line[10], ah
    mov byte ptr output_line[12], al

    mov al, dh
    call bcd2asc
    mov byte ptr output_line[16], ah
    mov byte ptr output_line[18], al

    mov cx, output_line_1
    push 0B800h
    pop es
    mov di, word ptr start_position
    mov si, offset output_line
    cld
    rep movsb
exit_handler:
    pop ds
    pop es
    popa
    jmp cs:old_int1Ch

bcd2asc proc near
    mov ah, al
    and al, 0Fh
    shr ah, 4
    add al, '0'
    add ah, '0'
    ret
bcd2asc endp

output_line db ' ',1Fh,'0',1Fh,'0',1Fh,'h',1Fh
            db ' ',1Fh,'0',1Fh,'0',1Fh,':',1Fh
            db '0',1Fh,'0',1Fh,' ',1Fh
output_line_1 equ $-output_line
int1Ch_handler endp
end start