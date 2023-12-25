IDEAL
MODEL small
STACK 100h
jumps
p186
DATASEG
;
	gameName db 10,13,10,13, '	Tetris Plus - Press Q to Quit' ,10,13,10,13,'$'
	score db 0
	lines db 0
	
	block db '#'
	
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

	x_cord1 db 7 ;column 
	y_cord1 db 7 ;row
	x_cord2 db 7
	y_cord2 db 6
	x_cord3 db 6 ;column 
	y_cord3 db 7 ;row
	x_cord4 db 6
	y_cord4 db 6
	color dw 0Eh ; color
;
CODESEG

proc setTBlock
	mov [x_cord1], 7
	mov [x_cord2], 8
	mov [x_cord3], 8
	mov [x_cord4], 9
	
	mov [y_cord1], 7
	mov [y_cord2], 7
	mov [y_cord3], 6
	mov [y_cord4], 7
endp setTBlock

proc setLeftLBlock
	mov [x_cord1], 7
	mov [x_cord2], 7
	mov [x_cord3], 8
	mov [x_cord4], 9
	
	mov [y_cord1], 6
	mov [y_cord2], 7
	mov [y_cord3], 7
	mov [y_cord4], 7
endp setLeftLBlock

proc setRightLBlock
	mov [x_cord1], 7
	mov [x_cord2], 8
	mov [x_cord3], 9
	mov [x_cord4], 9
	
	mov [y_cord1], 7
	mov [y_cord2], 7
	mov [y_cord3], 7
	mov [y_cord4], 6
endp setRightLBlock

proc setCursorPosition1
	pusha
	mov dh, [y_cord1] ; row
	mov dl, [x_cord1] ; column
	mov bh, 0 ; page number
	mov ah, 2
	int 10h
	popa
	ret
endp setCursorPosition1

proc setCursorPosition2
	pusha
	mov dh, [y_cord2] ; row
	mov dl, [x_cord2] ; column
	mov bh, 0 ; page number
	mov ah, 2
	int 10h
	popa
	ret
endp setCursorPosition2

proc setCursorPosition3
	pusha
	mov dh, [y_cord3] ; row
	mov dl, [x_cord3] ; column
	mov bh, 0 ; page number
	mov ah, 2
	int 10h
	popa
	ret
endp setCursorPosition3

proc setCursorPosition4
	pusha
	mov dh, [y_cord4] ; row
	mov dl, [x_cord4] ; column
	mov bh, 0 ; page number
	mov ah, 2
	int 10h
	popa
	ret
endp setCursorPosition4

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

	call setCursorPosition1

	inc [y_cord1]

	call drawBlack

	call setCursorPosition1

	call drawChar
; 
	call setCursorPosition2

	inc [y_cord2]

	call drawBlack

	call setCursorPosition2

	call drawChar
; 
	call setCursorPosition3

	inc [y_cord3]


	call drawBlack

	call setCursorPosition3

	call drawChar
; 
	call setCursorPosition4

	inc [y_cord4]


	call drawBlack

	call setCursorPosition4

	call drawChar

	cmp [y_cord1], 20
	jge pushUp
	cmp [y_cord4], 20
	jge pushUp
	cmp [y_cord2], 20
	jge pushUp
	cmp [y_cord3], 20
	jge pushUp

	popa
	ret
endp down

proc left
	pusha

	call setCursorPosition3

	dec [x_cord3]

	cmp [x_cord3], 0
	je pushRight

	call drawBlack

	call setCursorPosition3

	call drawChar
; 
	call setCursorPosition4

	dec [x_cord4]

	cmp [x_cord4], 0
	je pushRight

	call drawBlack

	call setCursorPosition4

	call drawChar
; 
	call setCursorPosition1

	dec [x_cord1]

	cmp [x_cord1], 0
	je pushRight

	call drawBlack

	call setCursorPosition1

	call drawChar
; 
	call setCursorPosition2

	dec [x_cord2]

	cmp [x_cord2], 0
	je pushRight

	call drawBlack

	call setCursorPosition2

	call drawChar
	popa
	ret
endp left

proc right
	pusha

	call setCursorPosition1

	inc [x_cord1]

	cmp [x_cord1], 13
	je pushLeft

	call drawBlack

	call setCursorPosition1

	call drawChar
; 
	call setCursorPosition2

	inc [x_cord2]

	cmp [x_cord2], 13
	je pushLeft

	call drawBlack

	call setCursorPosition2

	call drawChar
; 
	call setCursorPosition3

	inc [x_cord3]

	cmp [x_cord3], 13
	je pushLeft

	call drawBlack

	call setCursorPosition3

	call drawChar
; 
	call setCursorPosition4

	inc [x_cord4]

	cmp [x_cord4], 13
	je pushLeft

	call drawBlack

	call setCursorPosition4

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
	inc [x_cord1]
	inc [x_cord2]
	inc [x_cord3]
	inc [x_cord4]

jmp getKey

pushLeft:
	dec [x_cord1]
	dec [x_cord2]
	dec [x_cord3]
	dec [x_cord4]

jmp getKey

pushUp:
	call setLeftLBlock

jmp getKey

gravity:
	call down



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