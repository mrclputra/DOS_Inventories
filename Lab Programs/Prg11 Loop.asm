.model small
.stack 100h
.code
main proc
        mov cx,5
        mov ah,2

a:      mov dl,42 ; Asterisk (*)
        int 21h

        mov dl,9 ; Horizontal Tab
        int 21h

        loop a

        mov ah,4ch
        int 21h
main endp
end main

