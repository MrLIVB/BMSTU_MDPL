#include "pch.h"
#include <iostream>
#include <Windows.h>
#include <string>

using namespace std;

extern "C" {
	int my_copy(char *s1, char *s2, int l);
}

DWORD my_length(char *s)
{
	DWORD l = 0;
	__asm {
		cld
		mov edi, s
		mov esi, edi
		mov ecx, 0ffffffffh
		xor al, al
		repne scasb
		not ecx
		dec ecx
		mov l, ecx
	}
	return l;
}

void smt()
{
	__asm {
		xor dx, dx
		mov ax, 00FFh
		mov bx, 00FFh
		mul bx

	}
}

int main()
{
	smt();
	char s1[] = "123bajsbd";
	int l = my_length(s1);
	char *s2 = new char[l + 1];
	
	std::cout << l << std::endl;	
	my_copy(s1, s2, l);
	for (int i = 0; i < l; i++)
		std::cout << s2[i];
	return 0;
}

// Запуск программы: CTRL+F5 или меню "Отладка" > "Запуск без отладки"
// Отладка программы: F5 или меню "Отладка" > "Запустить отладку"

