.model small
.stack 100h
.code

main proc
        mov ah,2
        mov cx,26       ; set loop counter to 26
        mov dl,65       ; ascii for 'A'

loop1:
        ; keep printing alphabets
        int 21h       ; DOS interrupt to display character in DL (initially 'A')
        mov bl, dl    ; Save the current character in BL
        mov dl, " "   ; Set DL to space character
        int 21h       ; DOS interrupt to display space character
        mov dl, bl    ; Restore the character from BL to DL
        inc dl        ; Increment DL to get the next character
        dec cx        ; Decrement loop counter
        jnz loop1     ; If CX is not zero, jump to loop1

        mov ah, 2     ; Set function 2 of INT 21h to display output
        mov dl, 10    ; ASCII code for newline
        int 21h       ; DOS interrupt to display newline
        mov dl, 13    ; ASCII code for carriage return
        int 21h       ; DOS interrupt to display carriage return

        mov ah, 2     ; Set function 2 of INT 21h to display output
        mov cx, 26    ; Set loop counter to 26 (number of letters in the alphabet)
        mov dl, 97    ; ASCII code for 'a'

loop2:
        int 21h       ; DOS interrupt to display character in DL (initially 'a')
        inc dl        ; Increment DL to get the next character
        dec cx        ; Decrement loop counter
        jnz loop2     ; If CX is not zero, jump to loop2

        mov ah, 2     ; Set function 2 of INT 21h to display output
        mov dl, 10    ; ASCII code for newline
        int 21h       ; DOS interrupt to display newline
        mov dl, 13    ; ASCII code for carriage return
        int 21h       ; DOS interrupt to display carriage return

        mov ah, 2     ; Set function 2 of INT 21h to display output
        mov cx, 10    ; Set loop counter to 10 (number of digits)
        mov dl, 48    ; ASCII code for '0'


loop3:
        int 21h       ; DOS interrupt to display character in DL (initially '0')
        inc dl        ; Increment DL to get the next character
        dec cx        ; Decrement loop counter
        jnz loop3     ; If CX is not zero, jump to loop3

        mov ah, 4ch   ; Set function 4Ch of INT 21h to exit program
        int 21h       ; DOS interrupt to terminate program

main endp
end main
