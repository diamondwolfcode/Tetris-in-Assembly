IDEAL
MODEL small
STACK 100h
jumps
p186
DATASEG
;
	gameName db 10,13,10,13, 'Tetris Plus - Press Q to Quit' ,10,13,10,13,'$'
	score db 0
	lines db 0
	space db ' ','$'
	
	block db '#'
	
	rowLen dw 13
	colLen dw 5
	
	openingscreen db'                       ' , 10, 13
	db '==============' , 10, 13
	db '|            | SCORE' , 10, 13
	db '|	     | 0000' , 10, 13
	db '|            | ' , 10, 13
	db '|            | LEVEL' , 10, 13
	db '|            | 0' , 10, 13
	db '|            | LINES' , 10, 13
	db '|            | 0' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '|            |' , 10, 13
	db '==============' , 10, 13, '$'

	screen_size dw 20
	x_cord db 7 ;column 
	y_cord db 6 ;row
	x_cord2 dw 7,6,7,6
	y_cord2 dw 7,6,7,6
	color dw 0Eh ; color
;
CODESEG

proc setCursorPosition
	pusha
	mov dh, [y_cord] ; row
	mov dl, [x_cord] ; column
	mov bh, 0 ; page number
	mov ah, 2
	int 10h
	popa
	ret
endp setCursorPosition

proc drawBlack
	pusha

	mov ah, 9
	mov al, '' ; al - character to display
	mov bx, [0] ; bh - background, bl - foreground
	mov cx, 1 ; cx - number of times to write the character
	int 10h

	popa
	ret
endp drawBlack

proc drawChar
	pusha

	mov ah, 9
	mov al, [block] ; al - character to display
	mov bx, [color] ; bh - background, bl - foreground
	mov cx, 1 ; cx - number of times to write the character
	int 10h
	
	popa
	ret
endp drawChar

proc down
	pusha

	call setCursorPosition

	inc [y_cord]

	cmp [y_cord], 17
	je pushUp

	call drawBlack

	call setCursorPosition

	call drawChar

	popa
	ret
endp down

proc left
	pusha

	call setCursorPosition


	dec [x_cord]

	cmp [x_cord], 0
	je pushRight

	call drawBlack

	call setCursorPosition

	call drawChar

	popa
	ret
endp left

proc right
	pusha

	call setCursorPosition

	inc [x_cord]

	cmp [x_cord], 13
	je pushRight

	call drawBlack

	call setCursorPosition

	call drawChar

	popa
	ret
endp right

start:
	mov ax, @data
	mov ds, ax

; clear screen by entering 40*25
	mov ax, 13h
	int 10h
	

; print game frame

	mov dx, offset gameName 
	mov ah,9h 
	int 21h	

	mov dx, offset openingscreen
	mov ah, 9h
	int 21h

	mov dx, offset lines
	mov ah, 9h
	int 21h

; printUp:
; 	call up

; jmp getKey

printDown:
	call down

jmp getKey

printLeft:
	call left

jmp getKey

printRight:
	call right

jmp getKey

pushRight:
	mov [x_cord], 12

jmp getKey

pushLeft:
	dec [x_cord]

jmp getKey

pushUp:
	dec [y_cord]

jmp getKey

getkey:
	mov ah, 0h
	push ax
	int 16h

	; cmp al, 'w'
	; je printUp

	cmp al, 'd'
	je printRight
 
	cmp al, 's'
	je printDown

	cmp al, 'a'
	je printLeft

	cmp al, 'q'
	je exit

	loop getkey

	mov cx, 5



; print: 
; 	pop dx
; 	mov ah, 2h
; 	int 21h
; 	loop print

	
exit:
	mov ax, 2h
	int 10h
	mov ax, 4c00h
	int 21h
END start