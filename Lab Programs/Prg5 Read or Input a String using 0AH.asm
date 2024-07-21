.model small
.stack 100h
.data
    ; Define a buffer for the input
    buffer db 20      ; Maximum number of characters to read (including carriage return)
    db ?              ; Number of characters actually read
    db 20 dup('$')    ; Space for characters (buffer size minus 2 bytes for count)

.code

Main proc
	
	mov ax,@data
	mov ds,ax

	mov ah, 0Ah       ; DOS function to read buffered input
    lea dx, buffer    ; Load address of the buffer into DX
    int 21h           ; Call DOS interrupt

	mov ah,4ch
	int 21h

Main endp
End main
