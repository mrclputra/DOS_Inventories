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

    prompt_return db 'Enter to return to the main menu...$', 0
    invalid_msg db 'Invalid Input$', 0
    valid_msg db 'Valid Input$', 0
    input_msg db 'Enter Input : $', 0

    ; menu 1
    main_menu db 'Inventory Management System', 0Dh, 0Ah, '1. Display Inventory', 0Dh, 0Ah, '2. Sell Items', 0Dh, 0Ah, '3. Exit', 0Dh, 0Ah, 'Enter Input: $', 0
    exit_msg db 'Program Terminated$', 0

    ; inventory
    num_bananas dw 25   ; 16-bit integer value
    num_apples dw 14
    num_mangoes dw 18

    bananas_str db 'bananas : $', 0
    apples_str db 'apples : $', 0
    mangoes_str db 'mangoes : $', 0

    newline db 0Dh, 0Ah, '$'    ; CR LF sequence for new line
    buffer db 6 dup('$')        ; buffer to store ASCII representations


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

; print number macro, designed to work with immediate values
; if you want to use a data segment value, load into a register first.  Value is expected to be in AX register when invoked
printNum MACRO num
    LOCAL convertLoop, printLoop, highlightNum, convertLoopHighlight, printLoopHighlight, endPrintNum     ; define local labels

    push ax
    push bx
    push cx
    push dx

    mov ax, num
    cmp ax, 3           ; compare with 3
    jb highlightNum     ; if less than 3, jump to highlightnum

    mov bx, 10          ; Base 10
    xor cx, cx          ; Clear CX

convertLoop:
    xor dx, dx          ; Clear DX for division
    div bx              ; AX / 10, quotient in AX, remainder in DX
    add dl, '0'         ; Convert remainder to ASCII
    push dx             ; Push remainder onto stack
    inc cx              ; Increment digit count
    test ax, ax         ; Test if quotient is zero
    jnz convertLoop     ; If not zero, repeat

printLoop:
    pop dx              ; Pop digit from stack
    mov ah, 02h         ; DOS interrupt to print character
    int 21h
    loop printLoop     ; Loop until all digits are printed
    jmp endPrintNum

highlightNum:
    mov bx, 10            ; Base 10
    xor cx, cx            ; Clear CX

convertLoopHighlight:
    xor dx, dx            ; Clear DX for division
    div bx                ; AX / 10, quotient in AX, remainder in DX
    add dl, '0'           ; Convert remainder to ASCII
    push dx               ; Push remainder onto stack
    inc cx                ; Increment digit count
    test ax, ax           ; Test if quotient is zero
    jnz convertLoopHighlight ; If not zero, repeat

printLoopHighlight:
    pop dx                ; Pop digit from stack
    mov ah, 09h           ; BIOS function to write character and attribute
    mov al, dl            ; Load the digit character
    mov bh, 0             ; Page number (usually 0)
    mov bl, 45h           ; Attribute byte (foreground/background color)
    int 10h               ; Call BIOS interrupt 10h to display character
    loop printLoopHighlight ; Loop until all digits are printed

endPrintNum:
    pop dx
    pop cx
    pop bx
    pop ax
ENDM

printInventory MACRO
    print bananas_str
    mov ax, num_bananas
    printNum ax
    print newline

    print apples_str
    mov ax, num_apples
    printNum ax
    print newline

    print mangoes_str
    mov ax, num_mangoes
    printNum ax
    println newline
ENDM

getInput MACRO buffer
    mov ah, 0Ah     ; read buffered input
    lea dx, buffer  ; Load the effective address of the buffer into DX
    int 21h

    ; newline after getting input
    print newline
ENDM

exitProgram MACRO
    print exit_msg
    mov ah,4Ch
    int 21h
ENDM

; main procedure
main PROC
    mov ax,@data        ; load data segment
    mov ds,ax           ; initialize data segment register

start:
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
    je sellMenuLoop

    ; check for 3
    mov al, [input_buffer+2]
    cmp al, '3'
    exitProgram

    ; invalid input case
    println invalid_msg
    print input_msg
    jmp mainMenuLoop

sellMenuLoop:
    exitProgram

displayMenuLoop:
    println valid_msg
    print newline

    printInventory
    
    print prompt_return
    getInput input_buffer   ; placeholder
    jmp start

main ENDP
END main

; The actual physical address in memory is determined by combining the segment base address and the offset. 
; For example, if the segment base address is 0x2000 and the offset is 0x0010, the physical address would be calculated as:
    ; Physical Address = (Segment * 16) + Offset
    ; Physical Address = (0x2000 * 16) + 0x0010
    ; Physical Address = 0x20000 + 0x0010
    ; Physical Address = 0x20010