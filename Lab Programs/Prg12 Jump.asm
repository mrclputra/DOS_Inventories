.model small
.stack 100h
.code
MAIN    PROC
    mov bl,30   ; set register to 80
    mov ah,2    ; DOS function to display
    mov dl,'*'  ; character to display

top:  int 21h ; call DOS interrupt
      dec bl  ; decrease BL by one
      cmp bl,0    ; check if BL is zero
      jne top ; repeat if not equal to zero

    mov ah,4Ch  ; DOS terminate
    int 21h ; return to DOS
MAIN    ENDP
end MAIN