StkSeg  SEGMENT PARA STACK 'STACK'
		DB 200h DUP (?)
StkSeg  ENDS
;
DataS SEGMENT WORD 'DATA'
HelloMessage DB 13		 		 ;курсор поместить в нач.строки
			 DB 10				 ;перевести курсор на нов. стркоу
			 DB 'Hello, World !'  ;текст
			 DB '$'              ;ограничитель для функции DOS
DataS ENDS
;
Code SEGMENT WORD 'CODE'
	 ASSUME CS:Code, DS:DataS
DispMsg:	 
	 mov AX, DataS				 ;загрузка в AX адреса сегмента данных
	 mov DS, AX					 ;установка DS
	 mov DX, OFFSET HelloMessage ;DS:DX адрес стркои
	 mov CX, 3
marker:
	xor ax, ax
	 xor bx, bx
	 xor dx, dx
	 mov ax, 01FFh
	 mov bx, 01FFh
	 mul bx

	 mov AH, 9					 ;AH=09h выдать на дисплей строку
	 int 21h
	 mov AH, 7					 ;ввести символ без эха
	 int 21h					 ;вызов функции DOS
	 loop marker
	 mov AH, 4Ch				 ;AH=4ch завершить процесс
	 int 21h					 ;вызов функции DOS
code ENDS
	 END marker
