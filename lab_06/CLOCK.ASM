.186
code    segment
        assume  cs:code,ds:code
        org     100h
start:  
        jmp     load
        old_1C  dd 0

bcd2asc proc near
        mov     ah, al
        and     al, 0Fh
        shr     ah, 4
        or      ax, 3030h
        ret
bcd2asc endp

clock   proc far
        pusha
        push    es
        push    ds
        push    cs
        pop     ds

        mov     ah,  2
        int     1Ah

        mov     al, ch
        call    bcd2asc
        mov     byte ptr output_line[0], ah
        mov     byte ptr output_line[2], al

        mov     al, cl
        call    bcd2asc
        mov     byte ptr output_line[6], ah
        mov     byte ptr output_line[8], al

        mov     al, dh
        call    bcd2asc
        mov     byte ptr output_line[12], ah
        mov     byte ptr output_line[14], al

        mov     cx, output_line_1
        push    0B800h
        pop     es
        mov     di, word ptr start_position
        mov     si, offset output_line
        cld
        rep     movsb

        pop     ds
        pop     es
        popa
        jmp     cs:old_1C

start_position dw (80*0 + 70)*2
output_line db '0',1Fh,'0',1Fh,':',1Fh
            db '0',1Fh,'0',1Fh,':',1Fh
            db '0',1Fh,'0',1Fh
output_line_1 equ $-output_line
clock   endp
end_clock:

load:   
        mov     ax,  351Ch
        int     21h
        mov     word ptr old_1C,  bx
        mov     word ptr old_1C + 2,  es
        mov     ax,  251Ch
        mov     dx,  offset clock
        int     21h

        mov     ax,  3100h
        mov     dx, (end_clock - start + 10Fh) / 16
        int     21h
code    ends
end     start
