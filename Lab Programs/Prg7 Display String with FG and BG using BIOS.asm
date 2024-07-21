.model small
.stack 100h
.data
	msg db ‘APIIT’
.code
Main proc
	
	mov ax,@data
	mov es,ax

	mov ah,13h
	mov al,0
	mov bh,0
	mov bl,45
	mov cx,5
	mov dh,5
	mov dl,5
	mov bp, offset msg
	int 10h

	mov ah,4ch
	int 21h

Main endp
End main
