.model small
.stack 100h

; define data segment contents here
.data

; user input buffers
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


; define code segment contents here
.code

print MACRO str
    ; prints string from data segment
    mov dx, offset str
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
; macro to print numbers, works with immediate values
; if you want to use a data segment variable, load it into AX register, then pass the register as parameter
printNum MACRO num
    LOCAL convertLoop, printLoop, highlightNum, convertLoopHighlight, printLoopHighlight, endPrintNum     ; define local labels

    push ax
    push bx
    push cx
    push dx

    mov ax, num
    cmp ax, 3           ; compare with 3
    jb highlightNum     ; if less than 3, jump to highlightnum

    mov bx, 10          ; base 10
    xor cx, cx          ; clear CX

convertLoop:
    xor dx, dx          ; clear dx for division
    div bx              ; ax / 10, quotient in ax, remainder in dx
    add dl, '0'         ; convert remainder to ASCII
    push dx             ; push remainder onto stack
    inc cx              ; increment digit count
    test ax, ax         ; test if quotient is zero
    jnz convertLoop     ; if not zero, repeat

printLoop:
    pop dx              ; pop digit from stack
    mov ah, 02h         ; DOS interrupt print character
    int 21h
    loop printLoop      ; loop until all digits in stack are printed
    jmp endPrintNum

highlightNum:
    mov bx, 10          ; base 10
    xor cx, cx          ; clear CX

convertLoopHighlight:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz convertLoopHighlight

printLoopHighlight:
    pop dx                  ; pop digit from stack
    mov ah, 09h             ; BIOS function to write character and attribute
    mov al, dl              ; load digit character
    mov bh, 0               ; page number (usually 0)
    mov bl, 4Fh             ; attribute byte (foreground/background color)
    int 10h                 ; call BIOS interrupt 10h to display character
    loop printLoopHighlight ; loop until all digits are printed

endPrintNum:
    pop dx
    pop cx
    pop bx
    pop ax
ENDM


; prints inventory
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

; decrease inventory item by 1, takes variable as parameter
decrease MACRO var
    LOCAL noDecrease, done

    ; Check if the value is already 0
    mov ax, var           ; load the value of the variable into AX
    cmp ax, 0             ; compare ax with 0
    je noDecrease         ; If equal (value is 0), skip the decrement

    ; Decrease the value
    dec ax                ; decrease the value by one
    mov var, ax           ; store the new value back into the variable
    jmp done              ; exit

noDecrease:
    ; value is already 0, do nothing
    ; no action needed

done:
ENDM

; gets input from user, loaded into buffer passed in parameter
getInput MACRO buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    print newline
ENDM

; close/exit program
exitProgram MACRO
    print exit_msg
    mov ah, 4Ch
    int 21h
ENDM


; procedures below

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
    println invalid_msg
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
    print exit_msg
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
    mov al, [input_buffer+2]
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

; main procedure
main PROC
    mov ax, @data   ; load data segment
    mov ds, ax      ; initialize data segment register
    call mainMenu
    exitProgram     ; thoretically should not happen

main ENDP
END main