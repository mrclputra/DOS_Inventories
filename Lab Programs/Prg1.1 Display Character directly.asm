.model small
.stack 50h
.code
MAIN PROC
	mov ah,2
	mov dl,'*'
	int 21h

	mov ah,4ch
	int 21h
MAIN ENDP
END MAIN	