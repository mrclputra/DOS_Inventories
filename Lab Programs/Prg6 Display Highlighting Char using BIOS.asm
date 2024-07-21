.model small
.stack 100h
.code

Main proc
	
	mov ah,09h
	mov al,'A'
	mov bh,0	
	mov bl,45
	mov cx,7
	int 10h

	mov ah,4ch
	int 21h

Main endp
End main
	
