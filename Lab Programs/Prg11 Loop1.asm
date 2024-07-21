.model small
.stack 100h
.code
main proc
        mov cx,5
        mov ah,2

a:      mov dl,42
        int 21h

        mov dl,9
        int 21h

        loop a

        mov dl,10 ; Line Feed
        int 21h
        int 21h

        mov cx,8

b:      mov dl,200 ;&Egrave character
        int 21h

        mov dl,9
        int 21h

        loop b

        mov ah,4ch
        int 21h
main endp
end main


