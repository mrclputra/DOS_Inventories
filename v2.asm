.model small
.stack 100h

.data   ; data segment

; data buffer for inputs
input_buffer db 20
db ?
db 20 dup('$')

; utility messages
input_msg db 'Enter Input : $', 0
prompt_return db 'Enter to return to the main menu...$', 0
invalid_msg db 'Invalid Input$', 0
valid_msg db 'Valid Input$', 0
exit_msg db 'Program Terminated$', 0

newline db 0Dh, 0Ah, '$'    ; CR LF sequence for new line
buffer db 6 dup('$')        ; buffer to store ASCII conversion representations

; menus
main_menu_msg db 'Inventory Management System', 0Dh, 0Ah, '1. Display Inventory', 0Dh, 0Ah, '2. Sell Items', 0Dh, 0Ah, '3. Exit', 0Dh, 0Ah, 'Enter Input: $', 0
sell_menu_title db 'Select Item to Sell$' , 0
sell_menu_exit db '4. return to main menu $', 0

; inventory
num_bananas dw 3    ; 16-bit integer value
num_apples dw 2
num_mangoes dw 5

bananas_str db '1. bananas $', 0
apples_str db '2. apples $', 0
mangoes_str db '3. mangoes $', 0
; expand inventory if needed

.code   ; code segment

print MACRO str 
    mov dx, offset str   ; load the offset address of the parameter into dx
    mov ah, 09h
    int 21h
ENDM

println MACRO str
    mov dx, offset str
    mov ah, 09h
    int 21h
    mov dx, offset newline
    mov ah, 09h
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
    mov bl, 4Fh           ; Attribute byte (foreground/background color)
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
    print newline
ENDM

decrease MACRO var
    LOCAL noDecrease, done

    ; Check if the value is already 0
    mov ax, var           ; Load the value of the variable into AX
    cmp ax, 0             ; Compare AX with 0
    je noDecrease         ; If equal (value is 0), skip the decrement

    ; Decrease the value
    dec ax                ; Decrease the value by one
    mov var, ax           ; Store the new value back into the variable
    jmp done              ; Skip the noDecrease part

noDecrease:
    ; Value is already 0, do nothing
    ; No action needed if value is 0

done:
ENDM

getInput MACRO buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    print newline
ENDM

exitProgram MACRO
    print exit_msg
    mov ah, 4Ch
    int 21h
ENDM

displayMenu PROC
    ; procedure to display all items, accessed from main menu
    print newline
    printInventory
    print newline

    print prompt_return
    getInput input_buffer   ; placeholder
    ret
displayMenu ENDP

sellMenu PROC
    ; procedure to handle selling of items

startSell:
    print newline
    println sell_menu_title
    printInventory
    println sell_menu_exit   ; Ensure this message is defined in .data
    print input_msg

validateSell:
    getInput input_buffer
    ; Check for bananas
    mov al, [input_buffer+2]  ; Load the first character of input into AL
    cmp al, '1'
    je decBananas

    ; Check for apples
    mov al, [input_buffer+2]  ; Load the first character of input into AL
    cmp al, '2'
    je decApples

    ; Check for mangoes
    mov al, [input_buffer+2]  ; Load the first character of input into AL
    cmp al, '3'
    je decMangoes

    ; Check for exit
    mov al, [input_buffer+2]  ; Load the first character of input into AL
    cmp al, '4'
    je exitSell

    ; Invalid input
    print invalid_msg
    print input_msg
    jmp validateSell

decBananas:
    decrease num_bananas
    jmp startSell

decApples:
    decrease num_apples
    jmp startSell

decMangoes:
    decrease num_mangoes
    jmp startSell

exitSell:
    print newline
    print exit_msg          ; Ensure this message is defined in .data
    ret
sellMenu ENDP

mainMenu PROC
    ; procedure to handle main menu logic 

startMain:
    print main_menu_msg

validateMain:
    getInput input_buffer

    ; check for 1
    mov al, [input_buffer+2]  ; load the first character of input into AL
    cmp al, '1'
    je dspMenu

    ; check for 2
    mov al, [input_buffer+2]  ; load the first character of input into AL
    cmp al, '2'
    je sllMenu

    ; check for 3
    mov al, [input_buffer+2]
    cmp al, '3'
    je exitMain

    ; invalid input case
    println invalid_msg
    print input_msg
    jmp validateMain

dspMenu:
    call displayMenu
    jmp startMain

sllMenu:
    call sellMenu
    jmp startMain

exitMain:
    exitProgram

mainMenu ENDP

main PROC
    mov ax, @data   ; load data segment
    mov ds, ax      ; initialize data segment register
    call mainMenu
    exitProgram     ; thoretically should not happen

main ENDP
END main
