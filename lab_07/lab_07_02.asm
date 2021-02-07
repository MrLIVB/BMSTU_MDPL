.686
.MODEL FLAT, C
.STACK
.CODE


my_copy PROC src:DWORD, dst:DWORD, l:DWORD
	mov esi, src
	mov edi, dst
	mov ecx, l
	cmp esi, edi
	ja dst_lower
	je endf
	dst_higher:
	std
	add esi, ecx
	add edi, ecx
	rep movsb
	mov cl, [esi]
	mov byte ptr [edi], cl
	cld
	jmp endf

	dst_lower:
	cld
	rep movsb
	mov byte ptr [edi], 0
	endf:
	ret
my_copy endp
END