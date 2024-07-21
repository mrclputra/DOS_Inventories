.model small
.stack 100h
.code
Main proc
	
	mov ah,02h
	mov dl,65
	int 21h

	mov ah,4ch
	int 21h

Main endp
End main
