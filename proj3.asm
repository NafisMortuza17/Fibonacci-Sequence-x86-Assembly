   comment |
    	    ***************************************************************
   Programmer: Nafis Mortuza
   Date      :  March	27, 2022
    	    Course    :  CS221	Machine	Organization & Assembly	Language Programming
    	    Project   :  Project 3- Fibbonacci Series
    
    	    Assembler :  Borland TASM 3.0
    	    File Name :  MaxInput.asm
    
    
    
    	    PROCEDURES	CALLED:
    		External procedures called:
    		    FROM iofar.lib: PutCrLf, GetDec, PutDec
    		Internal procedures called:
    		    Greet
    
    	    |

    	    INCLUDELIB	iofar
    
    	    ;****** BEGIN MAIN	PROGRAM	************************************
    		    DOSSEG
    		    .186
    			.model large
    			 .stack 200h

            ;***********MAIN PROGRAM DATA SEGMENT******************************

            .data
            n dw ?
            ntemp dw ?
            prompt db 'Enter an int for fib series:$'
            echo db 'The integer you entered was:$'
            n3 dw 0
            n2 dw 1
            n1 dw 0
           
            ;***********MAIN PROGRAM CODE SEGMENT******************************

           .code 
           extrn   PutStr: PROC, PutCrLf: PROC
    	   extrn   GetDec: PROC, PutDec: PROC
    
            Programstart PROC
         
            mov ax, @data
            mov ds,ax


            call Greet

            mov dx,OFFSET prompt
            mov ah,09h
            int 21h

            

            
            call GetDec
            mov ntemp,ax
            sub ax,1    ;print 1 initially and call the function with Fibonacci (n-1,n1,n2,n3)
            mov n,ax

            mov dx,OFFSET echo
            mov ah,09h
            int 21h
            mov ax,ntemp
            call PutDec
            call  PutCrLf
            call  PutCrLf
          
            mov ax,1
            call PutDec
	    call  PutCrLf

            
          
            push OFFSET n3      ;Fibonacci(n,&n1,&n2,&n3)
            push OFFSET n2
            push OFFSET n1
            push n
            call Fibonacci
          
            ; Exit to the operating system
	        mov	ah,4ch	     ; DOS terminate program fn #
	        int	21h
            Programstart endp


         
     comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print initial greeting messages to the user
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	.data
Msgg1	 db  'Program: Fibonacci Sequence $'
Msgg2	 db  'Programmer:Nafis Mortuza $'
Msgg3	 db  'Date: March 30th, 2022 $'


;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Greet	PROC    near

; Save registers on the stack
	pusha
	pushf

; Print name of program
	mov	dx,OFFSET Msgg1 ; set pointer to 1st greeting message
	mov ah,09H        ; DOS print string function #
	int	21h	            ; print string
	call	PutCrLf

; Print name of programmer
	mov	dx,OFFSET Msgg2    ; set pointer to 2nd greeting message
mov ah,09H	           ; DOS print string function #
	int	21h	               ; print string
	call	PutCrLf

; Print date
	mov	dx,OFFSET Msgg3    ; set pointer to 3rd greeting message
	mov ah,09H           ; DOS print string function #
	int	21h	               ; print string
	call	PutCrLf
	call	PutCrLf


; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
Greet	ENDP


;****** FIBONACCI PROCEDURE**************************************
  
    .code
Fibonacci PROC near

pusha
pushf
mov bp,sp 

mov ax,[bp+20] ;ax=n

cmp ax,0 ;if n=0
jle exit ;return 0

mov bx, [bp+22]
mov si,[bx] ; si = n1

mov bx, [bp+24]
mov di,[bx] ; di = n2

add si,di

mov bx,[bp+26] ;n3
mov [bx],si ;n3=n1+n2


mov bx,[bp+24]
mov di,[bx]; si=n2

mov bx,[bp+22] ;n1
mov [bx],di   ;n1=n2


mov bx,[bp+26]
mov si,[bx] ;si=n3

mov bx,[bp+24] ;n2
mov [bx],si

mov bx,[bp+26] ;n3
mov ax,[bx]
call PutDec
call  PutCrLf



mov bx,[bp+26]
push bx ;push n3

mov bx,[bp+24]
push bx ;push n2

mov bx,[bp+22]
push bx ;push n1

mov ax,[bp+20]
dec ax
push ax

call Fibonacci

; deallocate the parameters from the  stack after the recursive call to prevent stack overflow
pop bx
pop bx
pop bx
pop bx 




exit:
popf
popa
ret


Fibonacci endp
end Programstart
