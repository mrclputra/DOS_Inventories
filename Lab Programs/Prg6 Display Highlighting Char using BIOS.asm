.model small
.stack 100h
.code

Main proc
	
	mov ah,09h	; write character to screen
	mov al,'A'	; load al with ASCII value of 'A', to be displayed
	mov bh,0	; set BH to 0 (page number, usually 0 for default display page)
	mov bl,45	; load BL with 45h (attribute byte for character display: foreground and background color)
	mov cx,7	; set counter to 7 (number of times to display the character)
	int 10h		; call BIOS interrupt 10h to display the character with the specified attributes

	mov ah,4ch	; terminate program
	int 21h

Main endp
End main
	
