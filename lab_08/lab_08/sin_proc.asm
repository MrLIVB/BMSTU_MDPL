.MODEL FLAT, C
.STACK
.DATA
i dd 2
minus dd -1
res dd 0
.CODE

my_sin PROC x:QWORD
	fld x ; слаг.
	fld x ; рез

	mov ecx, 4
	mov eax, 0
cycle:
	fmul x
	fmul x

	inc i
	fidiv i
	inc i
	fidiv i

	fmul minus
	fadd st(1), st
	loop cycle
	
	mov eax, res
	ret
my_sin ENDP
END