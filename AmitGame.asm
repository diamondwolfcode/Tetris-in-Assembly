IDEAL
MODEL small
STACK 100h
jumps
p186
DATASEG
;
    gameName db 10,13,10,13, '  Tetris Plus - Press Q to Quit' ,10,13,10,13,'$'
    lines db 0
    
    block db '#'
    
    gameboard db'---------------------',10,13
    
    openingscreen db'                       ' , 10, 13
                                       
    db '   _____ _____ _____ _____ _____ _____  ' , 10, 13
    db '  |_   _|   __|_   _| __  |     |   __|' , 10, 13
    db '    | | |   __| | | |    -|-   -|__   |  ' , 10, 13
    db '    |_| |_____| |_| |__|__|_____|_____|  ' , 10, 13
    db '       _____ __    _____ _____              ' , 10, 13
    db '      |  _  |  |  |  |  |   __|            ' , 10, 13
    db '      |   __|  |__|  |  |__   |            ' , 10, 13
    db '      |__|  |_____|_____|_____|            ' , 10, 13
    db '' , 10, 13
    db '        Made By: Amit Filber' , 10, 13
    db '        Press any key to start', 10, 13
    db '' , 10, 13, '$'

    gameOverScreen db '             ', 10, 13                         
db ' _____ _____ _____ _____   ', 10, 13
db '|   __|  _  |     |   __|  ', 10, 13
db '|  |  |     | | | |   __|  ', 10, 13
db '|_____|__|__|_|_|_|_____|  ', 10, 13
db ' _____ _____ _____ _____   ', 10, 13
db '|     |  |  |   __| __  |  ', 10, 13
db '|  |  |  |  |   __|    -|  ', 10, 13
db '|_____|\___/|_____|__|__|  ', 10, 13
db '                           ', 10, 13, '$'

    x_cord1 db 6 ;column 
    y_cord1 db 5 ;row
    x_cord2 db 6
    y_cord2 db 6
    x_cord3 db 6 ;column 
    y_cord3 db 7 ;row
    x_cord4 db 6
    y_cord4 db 8
    screenChr db '#'
    score db 10
    piece db 1
    y_curr db 0
    x_curr db 0
    color dw 0Eh ; color
    screen_height db 25
    screen_width db 21
    isCol db 0
;
CODESEG

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
    mov dx, 18
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

    mov dh, 0   ;set start position on y axis
    y:
        mov si, 0;counter for+
        mov dl, 1
        x:
            mov ah,2
            int 10h
            mov ah, 8
            int 10h
            cmp al, '+'
            jne noPlus
                inc si
            noPlus:

            mov ah, [screen_width]
            sub ah, 2
            inc dl
            cmp dl, ah
            jb x

        inc dl
        mov ah, 2
        int 10h

        add si, 3
        mov al, [screen_width]
        mov ah, 0
        cmp si, ax
        jne noFullLine
            mov dl, 1
            mov ah, 2
            int 10h
            printPluses:
                int 10h
                push dx
                mov dl, ' '
                int 21h
                pop dx


                mov bh, [score]
                add bh, 10
                mov [score], bh

                mov al, [screen_width]
                sub al, 2
                inc dl
                cmp dl, al
                jb printPluses

        noFullLine:


        inc dh
        cmp dh, [screen_height]
        jb y


    popa
    ret
endp checkLineFull

proc choosePiece
    pusha


    call random
    mov [block], "#"
    cmp [piece], 0
    je printTblock1
    cmp [piece], 1
    je printTblock2 
    cmp [piece], 2
    je printTblock3 
    cmp [piece], 3
    je printTblock4 
    cmp [piece], 4
    je printLeftLBlock1
    cmp [piece], 5
    je printLeftLBlock2
    cmp [piece], 6
    je printLeftLBlock3
    cmp [piece], 7
    je printLeftLBlock4
    cmp [piece], 8
    je printRightLBlock1
    cmp [piece], 9
    je printRightLBlock2
    cmp [piece], 10
    je printRightLBlock3
    cmp [piece], 11
    je printRightLBlock4
    cmp [piece], 12
    je printSquare
    cmp [piece], 13
    je printIblock1
    cmp [piece], 14
    je printIblock2
    cmp [piece], 15
    je printSBlock1
    cmp [piece], 16
    je printSBlock2
    cmp [piece], 17
    je printZBlock1
    cmp [piece], 18
    je printZBlock2

    call checkGameOver

    popa
    ret
endp choosePiece

proc checkGameOver
    cmp [y_cord1], 0
    je gameover
    cmp [y_cord2], 0
    je gameover
    cmp [y_cord3], 0
    je gameover
    cmp [y_cord4], 0
    je gameover

endp checkGameOver

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

proc setCursorPosition
    pusha
    mov dh, [x_curr] ; row
    mov dl, [y_curr] ; column
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

proc checkBorder
    pusha
    mov ah, [screen_height]
    sub ah, 2
    cmp [y_cord1], ah
    jge takePiece
    cmp [y_cord2], ah
    jge takePiece
    cmp [y_cord3], ah
    jge takePiece
    cmp [y_cord4], ah
    jge takePiece
    
    popa
    ret
endp checkBorder

proc collision  ;this procedure checks collision
    pusha

    call setCursorPosition1
    mov ah,3
    int 10h
    inc dh
    mov ah, 2
    int 10h
    mov ah, 8
    mov bh, 0
    int 10h
    cmp al, '+'
    je col1
    cmp al, 205
    jne noCol1
        col1:
        mov [isCol], 1
        jmp endCol
    noCol1:

    call setCursorPosition2
    mov ah,3
    int 10h
    inc dh
    mov ah, 2
    int 10h
    mov ah, 8
    mov bh, 0
    int 10h
    cmp al, '+'
    je col2
    cmp al, 205
    jne noCol2
        col2:
        mov [isCol], 1
        jmp endCol
    noCol2:

    call setCursorPosition3
    mov ah,3
    int 10h
    inc dh
    mov ah, 2
    int 10h
    mov ah, 8
    mov bh, 0
    int 10h
    cmp al, '+'
    je col3
    cmp al, 205
    jne noCol3
        col3:
        mov [isCol], 1
        jmp endCol
    noCol3:

    call setCursorPosition4
    mov ah,3
    int 10h
    inc dh
    mov ah, 2
    int 10h
    mov ah, 8
    mov bh, 0
    int 10h
    cmp al, '+'
    je col4
    cmp al, 205
    jne noCol4
        col4:
        mov [isCol], 1
        jmp endCol
    noCol4:


    mov [isCol], 0
    endCol:
    popa
    ret
endp collision

proc setToPlus
    pusha

    mov [block], '+'
    call setCursorPosition1
    call drawChar
    call setCursorPosition2
    call drawChar
    call setCursorPosition3
    call drawChar
    call setCursorPosition4
    call drawChar

    popa
    ret
endp setToPlus

proc down
    pusha


    call printBlack

    inc [y_cord1]
    inc [y_cord3]
    inc [y_cord4]
    inc [y_cord2]


    ; call checkCollison

    call collision
    cmp [isCol], 1
    je takePiece

    call checkBorder

    call print

    popa
    ret
endp down

proc right
    pusha

    call setCursorPosition1
    mov ah, 3
    int 10h
    add dl, 2
    cmp dl, [screen_width]
    jae endRight

    call setCursorPosition2
    mov ah, 3
    int 10h
    add dl, 2
    cmp dl, [screen_width]
    jae endRight

    call setCursorPosition3
    mov ah, 3
    int 10h
    add dl, 2
    cmp dl, [screen_width]
    jae endRight

    call setCursorPosition4
    mov ah, 3
    int 10h
    add dl, 2
    cmp dl, [screen_width]
    jae endRight

        ;if here than no collision with walls
        call printBlack
        inc [x_cord1]
        inc [x_cord2]
        inc [x_cord3]
        inc [x_cord4]
        call print


    endRight:
    popa
    ret
endp right

proc left
    pusha

    call setCursorPosition1
    mov ah, 3
    int 10h
    cmp dl, 1
    jbe endLeft

    call setCursorPosition2
    mov ah, 3
    int 10h
    cmp dl, 1
    jbe endLeft

    call setCursorPosition3
    mov ah, 3
    int 10h
    cmp dl, 1
    jbe endLeft

    call setCursorPosition4
    mov ah, 3
    int 10h
    cmp dl, 1
    jbe endLeft

        ;if here than no collision with walls
        call printBlack
        dec [x_cord1]
        dec [x_cord2]
        dec [x_cord3]
        dec [x_cord4]
        call print


    endLeft:

    popa
    ret
endp left

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

    mov ax, 13h
    int 10h

    mov [x_cord1], 0
    mov [y_cord1], 0
    call setCursorPosition1
    call eraseScreen
    mov dx, offset gameOverScreen
    call printString


    mov dl, score
    mov ah,2
    int 21h

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

printTblock1:
    mov [color], 4h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 1
    mov [y_cord2], 1
    mov [y_cord3], 2
    mov [y_cord4], 1
    call print

jmp getKey

printTblock2:
    mov [color], 4h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 8
    mov [x_cord4], 8
    
    mov [y_cord1], 2
    mov [y_cord2], 1
    mov [y_cord3], 2
    mov [y_cord4], 3
    call print

jmp getKey

printTblock3:
    mov [color], 4h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 8
    
    mov [y_cord1], 1
    mov [y_cord2], 2
    mov [y_cord3], 3
    mov [y_cord4], 2
    call print

jmp getKey

printTblock4:
    mov [color], 4h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 1
    mov [y_cord2], 1
    mov [y_cord3], 2
    mov [y_cord4], 1
    call print

jmp getKey

printLeftLBlock1:
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 1
    mov [y_cord2], 2
    mov [y_cord3], 2
    mov [y_cord4], 2
    call print

jmp getKey

printLeftLBlock2:
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 9
    mov [x_cord4], 9
    
    mov [y_cord1], 2
    mov [y_cord2], 2
    mov [y_cord3], 2
    mov [y_cord4], 1
    call print

jmp getKey

printLeftLBlock3:
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 8
    
    mov [y_cord1], 1
    mov [y_cord2], 2
    mov [y_cord3], 3
    mov [y_cord4], 3
    call print

jmp getKey

printLeftLBlock4:
    mov [color], 2h
    mov [x_cord1], 8
    mov [x_cord2], 8
    mov [x_cord3], 8
    mov [x_cord4], 7
    
    mov [y_cord1], 1
    mov [y_cord2], 2
    mov [y_cord3], 3
    mov [y_cord4], 3
    call print

jmp getKey

printRightLBlock1:
    mov [color], 2h
    mov [x_cord1], 6
    mov [x_cord2], 7
    mov [x_cord3], 8
    mov [x_cord4], 8
    
    mov [y_cord1], 2
    mov [y_cord2], 2
    mov [y_cord3], 2
    mov [y_cord4], 1
    call print

jmp getKey

printRightLBlock2:
    mov [color], 2h
    mov [x_cord1], 6
    mov [x_cord2], 6
    mov [x_cord3], 6
    mov [x_cord4], 7
    
    mov [y_cord1], 1
    mov [y_cord2], 2
    mov [y_cord3], 3
    mov [y_cord4], 3
    call print

jmp getKey

printRightLBlock3:
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 6
    
    mov [y_cord1], 3
    mov [y_cord2], 2
    mov [y_cord3], 1
    mov [y_cord4], 1
    call print

jmp getKey

printRightLBlock4:
    mov [color], 2h
    mov [x_cord1], 7
    mov [x_cord2], 6
    mov [x_cord3], 8
    mov [x_cord4], 8
    
    mov [y_cord1], 1
    mov [y_cord2], 1
    mov [y_cord3], 1
    mov [y_cord4], 2
    call print

jmp getKey

printSquare:
    mov [color], 1h
    mov [x_cord1], 7
    mov [x_cord2], 8
    mov [x_cord3], 9
    mov [x_cord4], 9
    
    mov [y_cord1], 2
    mov [y_cord2], 2
    mov [y_cord3], 2
    mov [y_cord4], 1
    call print

jmp getKey

printIBlock1:
    mov [color], 3h
    mov [x_cord1], 6
    mov [x_cord2], 7
    mov [x_cord3], 8
    mov [x_cord4], 9
    
    mov [y_cord1], 1
    mov [y_cord2], 1
    mov [y_cord3], 1
    mov [y_cord4], 1
    call print

jmp getKey

printIBlock2:
    mov [color], 3h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 7
    
    mov [y_cord1], 1
    mov [y_cord2], 2
    mov [y_cord3], 3
    mov [y_cord4], 4
    call print

jmp getKey

printSBlock1:
    mov [color], 0Eh
    
    mov [x_cord1], 6
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 8
    
    mov [y_cord1], 2
    mov [y_cord2], 2
    mov [y_cord3], 1
    mov [y_cord4], 1
    call print

jmp getKey

printSBlock2:
    mov [color], 0Eh
    
    mov [x_cord1], 6
    mov [x_cord2], 6
    mov [x_cord3], 7
    mov [x_cord4], 7
    
    mov [y_cord1], 3
    mov [y_cord2], 2
    mov [y_cord3], 2
    mov [y_cord4], 1
    call print

jmp getKey

printZBlock1:
    mov [color], 5h
    mov [x_cord1], 8
    mov [x_cord2], 7
    mov [x_cord3], 7
    mov [x_cord4], 6
    
    mov [y_cord1], 2
    mov [y_cord2], 2
    mov [y_cord3], 1
    mov [y_cord4], 1
    call print

jmp getKey

printZBlock2:
    mov [color], 5h
    mov [x_cord1], 7
    mov [x_cord2], 7
    mov [x_cord3], 8
    mov [x_cord4], 8
    
    mov [y_cord1], 2
    mov [y_cord2], 1
    mov [y_cord3], 1
    mov [y_cord4], 2
    call print

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
    call setToPlus
    call checkLineFull
    call choosePiece

jmp getKey

gameover:
    call callGameOver

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

    cmp al, 'y'
    je gameover

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