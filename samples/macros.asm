.model small
.stack 100h

; data segment
.data
    message db 'Hello World!$', 0
    ; ',0' adds a null byte after newline, use for padding
.code

; macro to print a string
print MACRO str
    mov dx,offset str   ; load the offset address of the parameter into dx
    mov ah,09           ; string display function
    int 21h             ; call DOS
ENDM

; main procedure
main PROC
    mov ax,@data        ; load data segment
    mov ds,ax           ; initialize data segment register

    print message       ; use macro

    mov ah,4Ch          ; exit function
    int 21h             ; call DOS
main ENDP
END main

; The actual physical address in memory is determined by combining the segment base address and the offset. 
; For example, if the segment base address is 0x2000 and the offset is 0x0010, the physical address would be calculated as:
    ; Physical Address = (Segment * 16) + Offset
    ; Physical Address = (0x2000 * 16) + 0x0010
    ; Physical Address = 0x20000 + 0x0010
    ; Physical Address = 0x20010