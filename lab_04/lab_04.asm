SSEG SEGMENT Stack
	dw 256 dup(?)
SSEG ENDS

DSEG SEGMENT para public 'DATA'
	c1 db 9 dup(0)
	c2 db 9 dup(0)
	c3 db 9 dup(0)
	c4 db 9 dup(0)
	c5 db 9 dup(0)
	c6 db 9 dup(0)
	c7 db 9 dup(0)
	c8 db 9 dup(0)
	c9 db 9 dup(0)
	rows db 0
	columns db 0
	minsumi db 0
	minsum db 0
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:SSEG
readmatr:
	xor cx, cx
	xor si, si
	mov cl, [rows]

	lines:
		mov dh, cl ;сохраняем значение cx внешнего цикла
		mov cl, [columns] ;записываем в cx количество символов строки
		xor di, di
		add di, si
		
		readline:		
			mov ah, 1
			int 21h
			mov [c1 + di], al
			inc di
			
			mov ah, 2
			mov dl, 20h
			int 21h
		loop readline

		mov dl, 0ah
		mov ah, 2
		int 21h
		add si, 9
		mov cl, dh ;возвращаем в cx значение цикла
	loop lines
	ret
	
outputmatr:
	xor cx, cx
	xor si, si
	mov cl, [rows]

	olines:
		xor di, di
		add di, si
		mov dh, cl ;сохраняем значение cx внешнего цикла
		mov cl, [columns]
		mov ah, 2
		
		outputline:
			mov dl, c1[di]
			int 21h
			mov dl, 20h
			int 21h
			inc di
		loop outputline

		mov dl, 0ah
		int 21h
		add si, 9
		mov cl, dh ;возвращаем в cx значение цикла
	loop olines

	ret

find_min_column_sum:
	xor cx, cx
	xor di, di
	xor si, si
	mov cl, [columns]

	rlines:
		mov dh, cl ;сохраняем значение cx внешнего цикла
		mov cl, [rows]
		mov di, si
		xor ah, ah ;сумма столбца
		findsum:
			mov bl, c1[di]
			sub bl, 30h
			add ah, bl
			
			add di, 9
		loop findsum
		
		cmp dh, [columns]
		jne furher
		jmp set_min_sum
		furher:
		cmp ah, [minsum]
		jb set_min_sum
		jae endofif
		set_min_sum:
			xchg ah, [minsum]
			xor ax, ax
			add ax, si
			xchg [minsumi], al
		endofif:
		inc si
		mov cl, dh ;возвращаем в cx значение внешнего цикла
	loop rlines
	ret

delete_column:
	xor cx, cx
	xor di, di
	xor si, si
	mov cl, [rows]
run_lines:
	mov dh, cl
	mov cl, [columns]
	xor ax, ax
	mov al, [minsumi]
	sub cl, al
	mov di, ax
	add di, si
	
	shift:
		mov ah, c1[di]
		xchg ah, c1[di + 1]
		mov byte ptr c1[di], ah
		inc di
	loop shift
	add si, 9
	mov cl, dh
	loop run_lines
	
	mov ah, columns
	dec ah
	xchg ah, columns
	ret
		

main:
	mov ax, DSEG
	mov ds, ax
	mov ax, SSEG
	mov ss, ax

;read_nrows	
	mov ah, 1
	int 21h
	sub al, 30h
	xchg al, rows
	
	mov ah, 2
	mov dl, 20h
	int 21h

;read_ncolumns
	mov ah, 1
	int 21h
	sub al, 30h
	xchg al, columns
	
	mov ah, 2
	mov dl, 0ah
	int 21h
	
	call readmatr
	call find_min_column_sum
	call delete_column
	call outputmatr
	
	mov ah, 2
	mov dl, 0ah
	int 21h
		
	mov ah, 4ch
	int 21h
CSEG ENDS
END main
