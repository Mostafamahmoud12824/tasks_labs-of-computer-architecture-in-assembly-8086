;auther mostafa mahmoud salah a program to find the sum of digits of a given number.
.code
org 100h


main proc near

; here is the section to read a valid 5 digit number and keep adding to dw sum   
numberreadstart:
    mov ah,09h  ; dos function 09h to display a string
    mov dx,offset messagereadnumber ; offset of message 
    int 21h     ; dos interrupt 21h
 
    mov sum,0
    mov cx,5    ; cx is set to 5 so that it loops 5 times to enter 5 digits of the number
readnumber:
    push cx
    
    
    mov ah,01h  ; read character from input store result in al
    int 21h     ; dos interrupt 21h
           
           
    ; code to check if the number is between 0 and 9          
    cmp al,30h  ; 30h is character 0  
    jl invalidnumber    ; If the number is less than character 0 jump to invalidnumber
    
    cmp al,39h  ; 39h is character 9
    jg invalidnumber    ; if the number is greater that character 9 jump to invalid number
    ; end code to check if the number is between 0 and 9 
    
    sub al,30h  ; 30h is the hex code for character 9 you subtract 30h to get the number and not character
    mov ah,00   
    add sum,ax  ; add sum = sum   number read
    
    pop cx
    loop readnumber     
    
    jmp validnumber 
    
invalidnumber:
    mov ah,09h
    mov dx,offset messageinvalidnumber
    int 21h
    jmp numberreadstart    
    
; end section to read a valid 5 digit number
    
validnumber:
  mov ax,sum
                
; code to convert decimal number to asii
  mov si,offset numbertoascii
  mov cx,00h
  mov bx,0ah
  hexloop1:
    mov dx,0
    div bx
    add dl,'0'
    push dx
    inc cx
    cmp ax,0ah
    jge hexloop1
    add al,'0'
    mov [si],al
  hexloop2:
    pop ax
    inc si
    mov [si],al
    loop hexloop2
  inc si
  mov [si],'$'
; end convert decimal number to asii

    mov ah,09h                      ;the funcation to display a string
    mov dx,offset displayresult ; offset of message to display since I am not terminating 
                                ; the string displayresult with a dollar it will print 
                                ; the displayresult also which terminates with a $ 
    int 21h                     ;interrupt 21h

            

    mov ah,4ch           ;the function to terminate and return to dos
    mov al,00
    int 21h                  ;the interrupt 21h
    
endp                                            
messageinvalidnumber db 0ah,0dh,"Invalid number$"
messagereadnumber db 0ah,0dh,"Please enter a 5 digit number $"
displayresult  db 0ah,0dh,"Sum of 5 digit number = "
numbertoascii db 5 dup(?)
sum dw 0
end main