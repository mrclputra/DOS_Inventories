.model small
.stack 100h

.data
N equ 10             
A db N dup(0)       
Sum db 0            

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov cx, N
    lea si, A 
      
input:

    mov ah, 1       
    int 21h         
    add [Sum], al    
    inc si
    loop input

   
    mov dl, [Sum]
    add dl, 30h       
    mov ah, 2       
    int 21h          

    mov ah, 4Ch  
    int 21h

main endp
end  main