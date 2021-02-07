#include "pch.h"
#include <iostream>
#include <Windows.h>

#define pi 3.1415926535897

double my_sin(double x)
{
	double res;
	int i = 1;
	float minus = -1;
	__asm {
		finit
		fld x
		fld x
		mov ecx, 4
		cycle:
		fmul minus
		fmul x
		fmul x
		inc i
		fidiv i
		inc i
		fidiv i
		fadd st(1), st
		loop cycle
		
		fxch st(1)
		fstp res
	}
	return res;
}

int main()
{
	std::cout << "Sin of pi/6 = " << my_sin(pi / 6) << std::endl;
	std::cout << "Sin of pi/2 = " << my_sin(pi / 2) << std::endl;
	std::cout << "Sin of 0 = " << my_sin(0) << std::endl;
	std::cout << "Sin of pi/4 = " << my_sin(pi / 4) << std::endl;
}
