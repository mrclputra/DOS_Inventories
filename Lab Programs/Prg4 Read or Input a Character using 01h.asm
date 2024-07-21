.model small
.stack 50h
.code

main proc
	mov ah,01h
	mov dl,al
	int 21h

	mov ah,02h
	mov dl,al
	int 21h

	mov ah,4ch
	int 21h
main endp
end main