.model small
.stack 100h
.code

Main proc
	
	mov ah,01h
	mov dl,al
	int 21h

	mov ah,4ch
	int 21h

Main endp
End main
