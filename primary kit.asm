;------------------------------------------
CODE	SEGMENT
	ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE	

command	equ	00
key	equ	01h
stat	equ 02
data	equ	04


		org 1000h
;----------------------init. varaibles-----------------                             
		array  db 0
		array2 db 0 
		val db 0
   mov     si,0
   mov     di,0
   
;------------------------main fun.---------------------

		call init
		mov si,offset str
start:	mov al,[si]
		cmp al,00
		je h1
		out data,al
		call busy
		inc si
		jmp start

h1:	
		 
		call busy 
		call scan
		mov bl, al  
		
		call init
		mov si,0
		jmp l1
		   

l1:     
mov  si,di
call input_numper
cmp  al,','
je pr
cmp  al,11h
je h
				           
loop l1

pr:
call prime_numper		  
		
h:		hlt 

;--------------------------main fun.-----------------------


 str		db "Enter the list:",00 
;---------------Display initialization procedure--------
init:	        call busy
		mov al,30h
		out command,al
		call busy
		mov al,0fh
		out command,al
		call busy
		mov al,06h
		out command,al
		call busy
		mov al,02
		out command,al
		call busy
		mov al,01
		out command,al
		call busy
		ret
		




;-----------------display ready procedure------------		
busy:	IN AL,Stat
		test AL,10000000b
		jnz busy
		ret
	
;------------------------keypad scan procedure---------------------	
scan:	IN AL,key					;read from keypad register
		TEST AL,10000000b			;test status flag of keypad register
		JNZ Scan
		AND al,00011111b			;mask the valid bits for code
		OUT key,AL					;get the keypad ready to read another key
		ret  
		
;-----------------------------------------------------  
;input numbers fun.
;take numbers from the kit
;return - output: the entered number into array[si]
;Inputs: the kit will put in AL
;-----------------------------------------------------
input_numper:

		call scan 
		cmp al,01h
		jne f2
f1:		
        mov al,'1'
		out data,al
		call busy
		mov array[si],1 
		inc si
		jmp lp	
	
        
f2:    
		cmp al,02h
		jne f3
		mov al,'2'
		out data,al
		call busy 
		mov array[si],2
		jmp lp

        
f3:    
		cmp al,03h
		jne f4
		mov al,'3'
		out data,al
		call busy 
		mov array[si],3
		inc si
		jmp lp	
		
f4:    
		cmp al,04h
		jne f5
		mov al,'4'
		out data,al
		call busy 
		mov array[si],4 
		inc si
		jmp lp
		
f5:    
		cmp al,05h
		jne f6
		mov al,'5'
		out data,al
		call busy
		mov array[si],5 
		inc si
		jmp lp					 
		       
f6:    
		cmp al,06h
		jne f7
		mov al,'6'
		out data,al
		call busy 
		mov array[si],6
		inc si
		jmp lp	
		
f7:    
		cmp al,07h
		jne f8
		mov al,'7'
		out data,al
		call busy 
		mov array[si],7
		inc si
		jmp lp			       
		       
	
		
f8:	
        cmp al,08h
		jne f9
		mov al,'8'
		out data,al
		call busy 
		mov array[si],8
		inc si
		jmp lp
				       
f9:	
        cmp al,09h
		jne f10
		mov al,'9'
		out data,al
		call busy 
		mov array[si],9 
		inc si
		jmp lp	
			           
f10:	
        cmp al,10h
		jne f0
		mov al,','
		;call prime_numper 
		;out data,al
		;call busy   
		mov array[si],44D ;',' 
		inc si
		jmp lp  

f0:	
        cmp al,00h
		jne k2
		mov al,'0'
		out data,al
		call busy 
		mov array[si],0
		inc si
		jmp lp

		 
 
				
k2:     
		cmp al,11h ;stp
		jmp h 
		jne lp
		call busy  

lp:		
		ret		
		
;-----------------------------------------------------  
;prime numbers checker fun.
;check numbers if that is prime or not 
;return - output: array[si] will be contain only prime numbers
;Inputs: the index of array SI and array[si]
;-----------------------------------------------------
prime_numper:   

   mov si,di
	


      MOV BH,0
	  MOV BL,10D
	   
	
	   INPUT:
	   ;MOV AH,1
	   ;INT 21H
	   mov AL,array[si]
	   CMP AL,44D
	   JNE NUMBER 
	   
	   JMP CHECK
	   
	   
	   NUMBER:
	   ;SUB AL,30H
	   MOV CL,AL
	   MOV AL,BH
	   MUL BL
	   ADD AL,CL
	   MOV BH,AL
	   inc si
	  ; mov cl,44D 
	   
	   JMP INPUT   
	   
	   CHECK:   
	   
	   CMP BH,1
	   ;mov al,BH ;new
	   JLE NOT_PRIME
	   
	   MOV CX,2
	   AND AX,0
	   AND DX,0
	   
	   MOV AL,BH
	   DIV CX
	   
	   MOV CX,AX            ;DX:AX / CX  = REM = DX , QUE = AX   
	   
	   ISPRIME:
	   CMP CX,2
	   JL PRIME
	   AND AX,0
	   AND DX,0
	   MOV AL,BH              ;DX:AX / CX  = REM = DX , QUE = AX 
	   DIV CX 
	   DEC CX
	   CMP DX,0
	   JE NOT_PRIME
	   JMP ISPRIME
	   
	   
	   
	   
	   PRIME:
	   mov si,di
	   ;mov di,0 
	   sr:
	   mov al,array[si]
	   ;mov bl,al
	   ;mov array2[di],bl
	   ;mov cl,array2[di]
	   inc si 
	   inc di
	   cmp al,44D 
	   jne sr 
	    
	   ;MOV AH,2 
	   ;MOV DL,0AH
	   ;INT 21H
	   ;MOV DL,0DH
	   ;INT 21H
	   ;MOV DL,'P'
	   ;INT 21H 
	   ;mov cx,
	   ;mov di,ax
	    ;mov  bL,array[si] 
	    
		;mov al,array2[0]
		;add BH,30h
		;out data,al
		;call busy 
		
	   JMP EXIT
	   
	   
	   NOT_PRIME: 
	;   dec di
;	   dec di
;	   ln: 
;	   mov al,array[di]	   
;	   cmp al,44D 
;	   dec di
;	   jne sr 
;	   inc di
	 
	   ;mov bL,array[si]
	   ;mov array2[0],9h
	   ;mov array2[0],5
		;mov al,array2[0]
		;add al,30h 
		;add BH,30h
		;out data,al
		;call busy
	   ;MOV AH,2 
	   ;MOV DL,0AH
	   ;INT 21H
	   ;MOV DL,0DH
	   ;INT 21H
	   ;MOV DL,'N'
	   ;INT 21H
	   ;mov array2[0],BH 
	   
	   ;mov array2[0],9
		 
	  	   
	  EXIT: 
	  
	  ;call scan
	 ; mov al,'0'
		;out data,al
		;call busy 
	  ret	   


;-----------------------------------------------------  
;print prime numbers fun.
;print all prime numbers  
;return - output: print on the LCD
;Inputs: the index of array SI and array[si]
;-----------------------------------------------------	

print:
dec di 
mov si,0
p: 
mov al,array[si] 
add al,30h
out data,al 
cmp si,di
inc si
jne p

ret	
		
		
CODE	ENDS
	END			