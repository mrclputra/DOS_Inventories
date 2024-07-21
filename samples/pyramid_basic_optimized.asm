.model small
.stack 100h
.code

MAIN PROC
    mov ah,02h          ; character display function
    mov bl,5            ; number of lines to display

    outer:
        mov cl,0        ; reset inner loop counter, this tracks number of written characters in a line
        mov ch,bl       ; set number of '*' for current line

        inner:
            mov dl,'*'  ; move '*' to display register
            int 21h     ; call DOS
            inc cl      ; increment inner loop counter
            cmp cl,ch   ; compare cl with ch
            jne inner   ; repeat inner loop if cl < ch

            mov dl,10   ; '\n' character, refer to ASCII tables
            int 21h     ; call DOS

            dec bl      ; decrement the line counter
            cmp bl,0    ; compare bl with 0
            jne outer   ; repeat outer loop if bl > 0

            mov ah,4Ch  ; exit function
            int 21h     ; call DOS
MAIN ENDP
END MAIN