.model small
.stack 100h
.code

MAIN PROC
    mov ah,02     ; character display function
    mov bl,5      ; base value is 3
    mov cl,0      ; counter low bit register start with 0
    mov ch,5      ; counter high bit register is 3


    top:                   ; this is the label name
            inc cl         ; increment the cl 
            mov dl,'*'     ; move '*' to the display register
            int 21h        ; call DOS

            cmp cl,ch      ; compare cl,ch if not equal 
            jne top        ; 'jump not equal', if not equal then go to top

            mov dl,10      ; '\n' to display register, refer to ASCII tables
            int 21h        ; call DOS

            mov cl,0       ; set cl to 0
            dec ch         ; decrement ch
            dec bl         ; decrement bl
            cmp bl,0       ; compare bl,0 is not equal
            jne top        ; jne-jump if not equal then go to top 

            mov ah,4ch     ; exit function
            int 21h        ; call DOS
MAIN ENDP
END MAIN

; equivalent C++ implementation
; #include <iostream>
; using namespace std;

; int main() {
;     int bl = 5;  // base value is 5
;     int cl = 0;  // counter low bit register start with 0
;     int ch = 5;  // counter high bit register is 5

;     while (true) {
;         while (cl != ch) {  // loop until cl equals ch
;             cl++;  // increment cl
;             cout << '*';  // display *
;         }

;         cout << '\n';  // new line

;         cl = 0;  // reset cl to 0
;         ch--;  // decrement ch
;         bl--;  // decrement bl

;         if (bl == 0) {  // exit condition
;             break;  // exit loop
;         }
;     }

;     return 0;  // exit program
; }