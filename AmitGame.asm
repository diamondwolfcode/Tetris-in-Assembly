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
	screen_height dw 25
	screen_width dw 21
;
CODESEG

proc printGameBoard

endp printGameBoard

proc printString ; prints a string based on offset value stored in dx
    pusha
    mov ah, 9h
    int 21h	;interrupt that displays a string
    popa
    ret
endp printString

proc printChr ; prints a character based on dl value. Does NOT use chr_to_print
    pusha
    mov ah, 2
    int 21h
    popa
    ret
endp printChr

proc drawMiddleRow ; draws a middle row of the screen
    pusha
    mov dl, 186
    call printChr
    mov cx, [screen_width]
    sub cx, 2
    drawMid:
        mov dl, ' '
        call printChr
    loop drawMid
    mov dl, 186
    call printChr
    mov dl, 10
    call printChr
    popa
    ret
endp drawMiddleRow

proc drawUpperRow ; draws the upper row of the screen border
    pusha
    mov dl, 201
    call printChr
    mov cx, [screen_width]
    sub cx, 2
    drawUp:
        mov dl, 205
        call printChr
    loop drawUp
    mov dl, 187
    call printChr
    mov dl, 10
    call printChr
    popa
    ret
endp drawUpperRow

proc drawLowerRow ; draws the bottom row of the screen border
    pusha
    mov dl, 200
    call printChr
    mov cx, [screen_width]
    sub cx, 2
    drawLow:
        mov dl, 205
        call printChr
    loop drawLow
    mov dl, 188
    call printChr
    mov dl, 10
    call printChr
    popa
    ret
endp drawLowerRow

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

	cmp [y_cord1], 23
	jge pushUp
	cmp [y_cord4], 23
	jge pushUp
	cmp [y_cord2], 23
	jge pushUp
	cmp [y_cord3], 23
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

	cmp [x_cord1], 21
	je pushLeft

	call drawBlack

	call setCursorPosition1

	call drawChar
; 

	call setCursorPosition2

	inc [x_cord2]

	cmp [x_cord2], 21
	je pushLeft

	call drawBlack

	call setCursorPosition2

	call drawChar
; 
	call setCursorPosition3

	inc [x_cord3]

	cmp [x_cord3], 21
	je pushLeft

	call drawBlack

	call setCursorPosition3

	call drawChar
; 
	call setCursorPosition4

	inc [x_cord4]

	cmp [x_cord4], 21
	je pushLeft

	call drawBlack

	call setCursorPosition4

	call drawChar
	popa
	ret
endp right

proc drawScreen
    pusha
    call drawUpperRow
    mov cx, [screen_height]
    sub cx, 2
    drawRows:
        call drawMiddleRow
    loop drawRows
    call drawlowerRow
    popa
    ret
endp drawScreen

start:
	mov ax, @data
	mov ds, ax

; clear screen by entering 40*25
	mov ax, 13h
	int 10h
	

; print game frame

	call drawScreen

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


getkey:
	mov ah, 1h
	int 16h
	jz not_pressed

		mov ah, 0h
		push ax
		int 16h
		jmp pressed
	not_pressed:
		mov al, 0
	pressed:

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

gravity:

	mov cx, 0fh
	mov dx, 4240h
	mov ah, 86h
	int 15h

	call printDown

	loop gravity

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
