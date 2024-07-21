.model small
.stack 100h
.code

; data segment
.data
    ; note, '0' is added after every string to use as memory padding

    ; buffer for input
    input_buffer db 20  ; maximum length
    db ?                ; number of characters actually read
    db 20 dup('$')      ; space for input characters

    invalid_msg db 'Invalid Input$', 0
    valid_msg db 'Valid Input$', 0
    input_msg db 'Enter Input : $', 0

    ; menu 1
    main_menu db 'Inventory Management System', 0Dh, 0Ah, '1. Display Inventory', 0Dh, 0Ah, '2. Sell Items', 0Dh, 0Ah, '3. Exit', 0Dh, 0Ah, 'Enter Input: $', 0

    exit_msg db 'Program Terminated$', 0

    ; inventory
    num_bananas db 25   ; 8-bit integer value
    ; num_apples dw 10    ; number of apples

    bananas_str db 'bananas : $', 0
    apples_str db 'apples : $', 0

    newline db 0Dh, 0Ah, '$'  ; CR LF sequence for new line
.code

; print string normally
print MACRO str
    mov dx,offset str   ; load the offset address of the parameter into dx
    mov ah,09
    int 21h
ENDM

; print string with newline
println MACRO str
    mov dx, offset str
    mov ah,09
    int 21h
    mov dx, offset newline
    mov ah,09
    int 21h
ENDM

getInput MACRO buffer
    mov ah, 0Ah     ; read buffered input
    lea dx, buffer  ; Load the effective address of the buffer into DX
    int 21h

    ; newline after getting input
    print newline
ENDM

intToStr MACRO num, buffer
    ; params:
    ; num: integer to convert
    ; buffer: pointer to destination buffer

    mov ax, num
    mov cx, 10
    mov di, buffer
    mov byte ptr [di], 0    ; null-terminate the string
    add di, 5               ; move to end of buffer
    dec di                  ; set pos to last digit

    test ax, ax
    jz ZeroCase:

ConvertLoop:
    xor dx, dx
    div cx
    add dl, '0'
    mov [di], dl
    dec di
    test ax, ax
    jnz ConvertLoop

ZeroCase:
    mov byte ptr [di], '0'
    ret

ENDM

; main procedure
main PROC
    mov ax,@data        ; load data segment
    mov ds,ax           ; initialize data segment register

    ; initialize main menu  
    print main_menu

mainMenuLoop:
    getInput input_buffer

    ; check for 1
    ; if valid, display items
    mov al, [input_buffer+2]  ; load the first character of input into AL
    cmp al, '1'
    je displayMenuLoop

    ; check for 2
    ; if valid go to sell items
    mov al, [input_buffer+2] 
    cmp al, '2'
    je exitProgram

    ; check for 3
    mov al, [input_buffer+2]
    cmp al, '3'
    je exitProgram

    ; invalid input case
    println invalid_msg
    print input_msg
    jmp mainMenuLoop

displayMenuLoop:
    println valid_msg

    print bananas_str
    println num_bananas 
    
    je exitProgram

exitProgram:
    print exit_msg
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