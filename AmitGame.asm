IDEAL
MODEL small
STACK 100h
jumps
p186
DATASEG
;
    gameName db 10,13,10,13, '  Tetris Plus - Press Q to Quit' ,10,13,10,13,'$'
    score dw 0
    lines db 0
    
    block db '#'
    
    gameboard db'---------------------',10,13
    
    openingscreen db'                       ' , 10, 13
    db '', 10, 13
    db '' , 10, 13
    db ' ______  _____ _____ ' , 10, 13
    db '|      ||    ||     ||    _ |  |   | |       | ' , 10, 13
    db '|_   _ ||   _||_   _||   | ||  |   | |  __| ' , 10, 13
    db '  | |   |  |_   | |  |   ||| |   | | |___  ' , 10, 13
    db '  | |   |   _|  | |  |    _  ||   | |__  | ' , 10, 13
    db '  | |   |  |_   | |  |   |  | ||   |  ___| | ' , 10, 13
    db '  |_|   |____|  |_|_|  |||_| |___|' , 10, 13
    db '         ____      _   _  ___         ' , 10, 13
    db '        |    ||   |    |  | |  ||       |        ' , 10, 13
    db '        |   _||   |    |  | |  ||  ___|        ' , 10, 13
    db '        |   | ||   |    |  ||  || |___         ' , 10, 13
    db '        |    _||   |_ |       ||___  |        ' , 10, 13
    db '        |   |    |       ||       | ___| |        ' , 10, 13
    db '        |_|    |__||__||___|        ' , 10, 13
    db '' , 10, 13
    db '              Made By: Amit Filber' , 10, 13
    db '' , 10, 13, '$'

    gameOverScreen db '             ', 10, 13
    db ' ___  ___  _   _  ___', 10, 13   
    db '|       ||   _   ||  |_|  ||       |', 10, 13    
    db '|    _||  ||  ||       ||    __|', 10, 13     
    db '|   | _ |       ||       ||   |__', 10, 13      
    db '|   ||  ||       ||       ||    _|', 10, 13     
    db '|   || ||   _   || |||| ||   |_', 10, 13      
    db '|__||| ||||   |||__|', 10, 13     
    db ' ___  _   _  ___  __', 10, 13       
    db '|       ||  | |  ||       ||    _ |', 10, 13      
    db '|   _   ||  ||  ||    __||   | ||', 10, 13      
    db '|  | |  ||       ||   |_ |   |||', 10, 13     
    db '|  ||  ||       ||    _||    _  |', 10, 13    
    db '|       | |     | |   |_ |   |  | |', 10, 13    
    db '|__|  |_|  |__||_|  |_|', 10, 13 
    



    x_cord1 db 6 ;column 
    y_cord1 db 5 ;row
    x_cord2 db 6
    y_cord2 db 6
    x_cord3 db 6 ;column 
    y_cord3 db 7 ;row
    x_cord4 db 6
    y_cord4 db 8
    x_tmp1 db 0
    y_tmp1 db 0
    x_tmp2 db 0
    y_tmp2 db 0
    screenChr db '#'
    piece db 1
    y_curr db 0
    x_curr db 0
    color dw 0Eh ; color
    screen_height db 25
    screen_width db 21
    count db 0
;
CODESEG

; proc checkCol
;     pusha
;     ; Calculate the pixel's memory address
;     mov ah, 0Dh ; Function to read pixel color
;     mov bh, 0   ; Display page number (usually 0 for single-page modes)
;     mov cl, [x_tmp1]   ; X coordinate of the pixel
;     mov dl, [y_tmp1]   ; Y coordinate of the pixel
;     int 10h     ; Call BIOS interrupt
;     ; After this call, AL will contain the color of the pixel
;     popa
;     ret
; endp

proc gameEnterScreen ; prints "Press any button to start" title screen
    pusha 
    mov [x_cord1], 0
    mov [y_cord1], 0
    call setCursorPosition1
    mov dx, offset openingscreen
    call printString
    popa 
    ret
endp gameEnterScreen

proc random
    popa
    mov ah, 2Ch
    int 21h

    mov al, dl
    mov ah, 0
    mov dx, 6
    mul dx
    mov bx, 100
    mov dx, 0
    div bx

    mov [piece],al ; call interrupt to display a value in DL
    pusha
    ret
endp random

proc readScreenChr
    pusha
        mov bh, 0h          ; Page=0
        mov ah, 02h         ; Set cursor position function
        mov dh, [y_cord1]       ; Load the row (Y-coordinate)
        mov dl, [x_cord1]       ; Load the column (X-coordinate)
        int 10h             ; Set the cursor position
        call setCursorPosition1

        mov ah, 08h         ; Read character function
        int 10h             ; Read character at the specified position into AL
        mov [screenChr], al ; Store the character in [screenChr]
    popa
    ret
endp readScreenChr  

proc checkLineFull
    pusha

    mov dh, [screen_height]

    inc dh
    check_rows:
        dec dh
        
        mov ch, [screen_width]
        inc ch
        check_cols:
            mov [y_tmp2], dh
            mov [x_tmp2], ch
            dec ch
            mov al, [y_tmp2]
            mov [y_tmp1], al
            mov al, [x_tmp2]
            mov [x_tmp1], al

            ; ; call checkCol

            ; cmp ah, 0
            ; jmp inc_counter
            inc_counter:
                inc [count]

        loop check_cols
        mov bh, [count]
        cmp bh, [screen_width]
        jmp clear_line

        clear_line:
            mov [y_curr], dh
            ; call clearLine
    loop check_rows

    
    popa
    ret
endp checkLineFull

; proc clearLine:
;     pusha
;     mov bh, [screen_width]
;     inc bh
;     clear:
;         dec bh
;         mov [x_curr], bh
;         call setCursorPosition
;         call drawBlack
;     loop clear
;     popa
;     ret
; endp clearLine

proc choosePiece
    pusha

    call random

    cmp [piece], 0
    je printTblock
    cmp [piece], 1
    je printLeftLBlock
    cmp [piece], 2
    je printRightLBlock
    cmp [piece], 3
    je printSquare
    cmp [piece], 4
    je printIBlock
    cmp [piece], 5
    je printZBlock
    cmp [piece], 6
    je printSBlock

    popa
    ret
endp choosePiece

proc printString ; prints a string based on offset value stored in dx
    pusha
    mov ah, 9h
    int 21h ;interrupt that displays a string
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
    mov cl, [screen_width]
    sub cl, 2
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
    mov cl, [screen_width]
    sub cl, 2
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
    mov cl, [screen_width]
    sub cl, 2
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
    pusha
    mov [color], 4h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 7
    mov [y_cord2], 7
    mov [y_cord3], 6
    mov [y_cord4], 7
    popa
    ret
endp setTBlock

proc setLeftLBlock
    pusha
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 6
    mov [y_cord2], 7
    mov [y_cord3], 7
    mov [y_cord4], 7
    popa
    ret
endp setLeftLBlock

proc setRightLBlock
    pusha
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 6
    mov [x_cord4], 6
    
    mov [y_cord1], 7
    mov [y_cord2], 6
    mov [y_cord3], 7
    mov [y_cord4], 6
    popa
    ret
endp setRightLBlock

proc setSquare
    pusha
    mov [color], 1h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 9
    mov [x_cord4], 9
    
    mov [y_cord1], 7
    mov [y_cord2], 7
    mov [y_cord3], 7
    mov [y_cord4], 6
    popa
    ret
endp setSquare

proc setIblock
    pusha
    mov [color], 3h
    mov [x_cord1], 6
    mov [x_cord2], 7
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 7
    mov [y_cord2], 7
    mov [y_cord3], 7
    mov [y_cord4], 7
    popa
    ret
endp setIblock

proc setSBlock
    pusha
    mov [color], 0Eh
    mov [x_cord1], 6
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 8
    
    mov [y_cord1], 7
    mov [y_cord2], 7
    mov [y_cord3], 6
    mov [y_cord4], 6
    popa
    ret
endp setSBlock

proc setZBlock
    pusha
    mov [color], 5h
    mov [x_cord1], 6
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 8
    
    mov [y_cord1], 6
    mov [y_cord2], 6
    mov [y_cord3], 7
    mov [y_cord4], 7
    popa
    ret
endp setZBlock

proc setCursorPosition
    pusha
    mov dh, [y_curr] ; row
    mov dl, [x_curr] ; column
    mov bh, 0 ; page number
    mov ah, 2
    int 10h
    popa
    ret
endp setCursorPosition


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

proc printBlack
    call setCursorPosition1
    call drawBlack
    call setCursorPosition3
    call drawBlack
    call setCursorPosition4
    call drawBlack
    call setCursorPosition2
    call drawBlack
    ret
endp printBlack

proc print
    call setCursorPosition1
    call drawChar
    call setCursorPosition3
    call drawChar
    call setCursorPosition4
    call drawChar
    call setCursorPosition2
    call drawChar
    ret
endp print

proc down
    pusha
    call printBlack

    mov ah, [screen_height]
    dec ah

    inc [y_cord1]
    cmp [y_cord1], ah
    jge takePiece
    inc [y_cord3]
    cmp [y_cord3], ah
    jge takePiece
    inc [y_cord4]
    cmp [y_cord4], ah
    jge takePiece
    inc [y_cord2]
    cmp [y_cord2], ah
    jge takePiece

    call print

    popa
    ret
endp down

proc left
    pusha
    call printBlack
    dec [x_cord3]
    cmp [x_cord3], 0
    je pushRight
    dec [x_cord4]
    cmp [x_cord4], 0
    je pushRight
    dec [x_cord1]
    cmp [x_cord1], 0
    je pushRight
    dec [x_cord2]
    cmp [x_cord2], 0
    je pushRight

    call print
    popa
    ret
endp left

proc right
    pusha
    call printBlack
    inc [x_cord3]
    cmp [x_cord3], 20
    je pushLeft
    inc [x_cord4]
    cmp [x_cord4], 20
    je pushLeft
    inc [x_cord1]
    cmp [x_cord1], 20
    je pushLeft
    inc [x_cord2]
    cmp [x_cord2], 20
    je pushLeft

    call print
    popa
    ret
endp right

proc drawScreen
    pusha
    call drawUpperRow
    mov cl, [screen_height]
    sub cl, 2
    drawRows:
        call drawMiddleRow
    loop drawRows
    call drawlowerRow
    call choosePiece
    popa
    ret
endp drawScreen

proc eraseRow ; prints a space 40 times then goes down line
    pusha
    mov cx, 40
    erase_row:
        mov dl, ' '
        mov [color], 0
        call printChr
    loop erase_row
    mov dl, 10
    call printChr
    popa 
    ret
endp eraseRow

proc eraseScreen ; prints 25 lines of spaces, with procedure eraseRow
    pusha
    mov [x_cord1], 0
    mov [y_cord1], 0
    call setCursorPosition1
    mov cx, 25
    erase_all:
        call eraseRow
    loop erase_all
    popa
    ret
endp eraseScreen

proc callGameOver
    pusha
    call eraseScreen
    mov [x_cord1], 0
    mov [y_cord1], 0
    call setCursorPosition1
    mov dx, offset gameOverScreen
    call printString
    mov [x_cord1], 0
    mov [y_cord1], 17
    call setCursorPosition1
    ;mov dx, offset score_msg
    call printString
    mov bl, 10
    mov ax, [score]
    div bl
    popa
    ret
endp callGameOver

start:
    mov ax, @data
    mov ds, ax

; clear screen by entering 40*25
    mov ax, 13h
    int 10h
    
    mov dx, offset openingscreen
    mov ah, 9h
    int 21h
    
; wait for character
    mov ah,0h
    int 16h

; print game frame

    call drawScreen

printTblock:
    call setTblock

jmp getKey

printLeftLBlock:
    call setLeftLBlock

jmp getKey

printRightLBlock:
    call setRightLBlock

jmp getKey

printSquare:
    call setSquare

jmp getKey

printIBlock:
    call setIblock

jmp getKey

printSBlock:
    call setSBlock

jmp getKey

printZBlock:
    call setZBlock

jmp getKey

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
    call right

jmp getKey

pushLeft:
    call left

jmp getKey

takePiece:
    call choosePiece

jmp getKey

call_check_line_full:
    call checkLineFull

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
;   pop dx
;   mov ah, 2h
;   int 21h
;   loop print

    
exit:
    mov ax, 2h
    int 10h
    mov ax, 4c00h
    int 21h
END start
