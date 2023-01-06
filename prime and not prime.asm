;Auther: Mostafa Mahmoud salah 
;for some of the prime numbers(19,23,31,37) its showing its not a prime number. Rest of the prime numbers(2,3,5,7,11,17,29,41,...,71) 
;A prime number is a number bigger than 1, that is only divisible by itself and by 1.
.STACK 100H
.DATA SEGMENT 
ARRAY DB DUP('$')

          NUM       DB      ?             ;flag value is undefined
          MSG1      DB      0AH,0DH,'ENTER YOUR DESIRED NUMBER:','$'
          MSG2      DB      0AH,0DH,'NOT A PRIME NUMBER','$'
          MSG3      DB      0AH,0DH,'A PRIME NUMBER','$'  
          POSI      DB      0AH,0DH,'A POSITIVE NUMBER','$'
          NEGA      DB      0AH,0DH,'A NEGATIVE NUMBER','$'

.CODE SEGMENT
MAIN    PROC

            MOV AX,@DATA         ; initialize data segment
            MOV DS,AX            ;Copy word from AX to DS register
            MOV SI, OFFSET ARRAY

            LEA DX,MSG1              ;Load DX with offset of msg1 in DS
            MOV AH,9                  ;set AH to 9  
            
            INT 21H
    
            MOV AH,1                   ;set AH to 1 
            INT 21H
            
            CMP AL,13
            JE CHECK
            MOV [SI],AL          ;Copy byte from memory at [si] to AL
            INC SI               ;Increment source index to point to next location
            JMP L1

    L1:
    MOV AH,1
    INT 21H
    CMP AL,13
    JE CHECK
    MOV [SI],AL             ;Put result back in source index
    INC SI                  ;Increment source index to point to next location
    JMP L1 
    
    CHECK:
    CMP ARRAY, '-'          ;IF ARRAY CONTAINS - SIGN THEN THE NUMBER IS NEGATIVE
    JE L2                   ;Jump if Equal (=) ZF = 1.
	
    
    MOV DX, OFFSET POSI     ;IF ARRAY CONTAINS SIGN THE NUMBER IS Positive
    MOV AH,9
    INT 21H  
    
    JMP EXIT1

    L2:
    MOV DX, OFFSET NEGA
    MOV AH,9
    INT 21H 
    
   ;-- If you find that the first byte at ARRAY is '-'  then better not start the prime test
        
EXIT1:  mov     al, [ARRAY]         ; ["0","9"]
        sub     al, 48              ;  [0,9]
        mov     bl, al              ;
        mov     bh, 0               ; AL -> BX (original number)Set byte of BX to all 0s

        mov     cl, al
        mov     ch, 0
        sub     cx, 2               ; AL-2 -> CX (loop count)
        jbe     YES                 ; Consider [0,2] prime for simplicity!
        mov     dl, 2
                                    ; Processing [3,9] with CX=[1,7] so LOOP doesn't fail
l3:     mov     ax, bx              ;Copy content of register BX to AX
        div     dl                  ;Divide word in AX by byte in DL; Quontient in AL, remainder in AH
        cmp     ah, 0               ;Compare immediate number 0H with byte in AH
        je      NO                  ;Jump if Equal (!=) zero flag = 0 then no jmp to label l3 .
        inc     dl                  ;Add 1 to contains of DL 
        loop    l3
                                       
                                       
                                       ;"Yes" - equal prime!
YES:    mov     ah, 9h                 ;Put immediate number 9H to ah
        lea     dx, msg3               ;Load DX with offset of msg3(prime_number) in DS
        int     21h
        jmp     end
                                                           
                                                           
                                       ; "NO" - equal!                    
NO:     mov     ah, 9h                 ;Put immediate number 9H to ah
        lea     dx, msg2               ;Load DX with offset of msg2(not a prime_number) in DS(data segment) 
        int     21h

END:    mov     ax, 4C00h              ;Put immediate number 4c00H to AX register
        int     21h                    ; call the interrupt handler 0x21 which is the DOS Function dispatcher. the "mov ah,01h" is setting AH with 0x01, 
                                       ; which is the Keyboard Input with Echo handler in the interrupt
    
    MAIN ENDP
 END MAIN                               ;exit