;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   PROGRAM TO INPUT & PRINT ANY  NON-NEGATIVE INTEGER <65,536  ;
;        IN ASSEMBLY LANGUAGE(8086) (implemented in DOSBOX):    ;
;			  Coded by-                             ;
; 		    Samiul Abid Chowdhury,                      ;
;	      Student at department of EEE, BUET                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.model large
.stack 100h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Just read the instructions inside the .data & .code  sections   ;
; below and you will be able to understand everything by yourself ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.data
sum dw 0         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		 ; "sum" WILL CONTAIN THE LATEST INPUT NUMBER ;
		 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		 ;if this code is run as it is now, then a single
		 ;number can be taken as input and the number will
		 ;be stored inside "sum".But if a second number is to be taken
		 ;as input, then follow the instructions presented as comment
		 ;just beside the variable "num1" below,then you'll be able
		 ;to input 2nd number but after the 2nd input is taken, "sum" will
		 ;contain the 2nd number in it as this will be the latest input 
		 ;number so far.This happening will continue after taking each input.
string1 db "Enter the number here: $"
num1 db 10 dup(?)                  ;the 1st input number(may be the only) you'll enter
				   ;in the dosbox console will be stored in this array
				   ;each digit one after another, e.g: if the 1st number
				   ;you take as input from the dos console is 245, then
				   ;num1[0]=1st digit=2,num1[1]=2nd digit=4 and so on.
				   ;If you want to input more than 1 numbers as input,
				   ;declare new array(s), e.g,"num2" just like "num1".
				   ;e.g: 'num2 db 10 dup(?)'.
				   ;In that case, num2[0]=1st digit of 2nd input number,
				   ;num2[1]=2nd digit of the 2nd input number and so on.
				   ;Also change 'string1 db "Enter the number here: $"'
				   ; to 'string1 db "Enter the 1st number here: $"'.
				   ;& declare string2, string3 in the 
				   ;same way like string1.
				   ;e.g: 'string2 db "Enter the 2nd number here: $"'.
				   ;Lastly, copy,paste all the codes inside the 
				   ;MAIN PROC(upto before "exit") and just change all the
				   ;"num1"(including those inside comments) to "num2"
				   ;(or change "num1" to or whatever is the name of the
				   ;array containing digits of the latest input,e.g,num3).
				   ;THUS YOU CAN INPUT ANOTHER NUMBER (INSIDE THE
				   ;VARIABLE "sum" WHICH IS DECLARED ABOVE).

				   ;BUT REMEMBER: 
				   ; 1) (FOLLOWING THE ABOVE INSTRUCTIONS)
				   ;EVERY TIME YOU ENTER A NEW INPUT, THE
				   ;VARIABLE "lenNum"(declared below) WILL CONTAIN
				   ;THE LENGTH of(or number of digits in) THE LATEST 
				   ;INPUT NUMBER & THE VARIABLE "sum"(declared above)
				   ;WILL CONTAIN THE LATEST INPUT NUMBER IN IT.
				   ;SO, BEFORE INPUTTING A NEW NUMBER(if required), IT'S
				   ;ADVISIBLE TO STORE VALUES of "lenNum" and "sum"
				   ;INSIDE REGISTERS FOR FURTHER USE. 
				   ; 2)PUSH AX,BX,CX,DX VALUES(if required) 
				   ;BEFORE THE "call recombiner" INSTRUCTION IN "MAIN PROC".
				   ;BEACUSE THIS FUNCTION "recombiner" WILL ALTER VALUES 
				   ;INSIDE ALL THOSE 4 REGISTERS.
				   ; 3)PUSH AX(IF REQUIRED) BEFORE EVERY FUNCTION CALL INSIDE
				   ;MAIN PROC BECAUSE YOU KNOW, EVERY TIME A FUNCTION IS
				   ;CALLED THE FUNCTION RETURNS IN 'AX' REGISTER.

first_address dw ?                 ;first address of the latest input number,
				   ;e.g: num1 or num2(whichever is the latest).
				   ;You don't need to do anything with this variable.

lenNum dw ?                        ;it contains the length of latest input number

;string_numLength db "The length of the number is: $"
				    ;Uncomment this variable if u want to print
				    ;the length of(no of digits in) the input.

;stringReprintInputNumber db "The number you just entered is: $"
				     ;Uncomment this variable if you want to reprint
				     ;the input in dos console.

base_number dw ? ;You don't need to do anything with this variable.
power dw ?       ;You don't need to do anything with this variable.
;;Enter other data here(if required):


.code

;************function to move cursor to newline begins****************
newline_function:
xor dx,dx
mov dx,10
mov ah,02h
int 21h
mov dx,13
mov ah,02h
int 21h
xor ax,ax
ret
;************function to move cursor to newline ends*******************

;****************power calculating function begins*********************
;Required Inputs: base_number & power
pow:
mov ax,1
mov cx,power
cmp cx,0
je power_zero
power_calc_loop:
mul base_number
Loop power_calc_loop
jmp exiting_pow
power_zero:
mov ax,1
exiting_pow:
ret
;*******************power calculating function ends**********************

;***************function to input any number begins**********************
inputAnyNumber:
mov first_address,si

loop_for_entering_number:
mov ah,01h
int 21h
mov ah,al
sub ah,48
mov [si],ah
inc si
cmp al,13
jne loop_for_entering_number

dec si
sub si,first_address
mov lenNum,si
mov ax,lenNum
ret
;*********************function to input any number ends*******************

;*function to Recombine the number's digits to form the original number begins*
;******************************************************************************
recombiner:
xor dx,dx
mov bx,lenNum
dec bx
mov ax,10
mov base_number,ax
original_number_forming_loop:
mov power,bx
call pow
mov dl,[si]
mov dh,0
mul dx
add sum,ax
dec bx
inc si
cmp bx,0
jnl original_number_forming_loop
ret
;******************************************************************************
;*function to Recombine the number's digits to form the original number ends***

MAIN PROC FAR
mov ax,@data
mov ds,ax

;;********************INPUTTING THE NUMBER begins:***************************
lea dx,string1
mov ah,09h
int 21h
xor dx,dx
mov si,offset num1 
call inputAnyNumber
;*********************INPUTTING THE NUMBER ends******************************
;Now, "num1" contains the input number's digits sequentially as an array
;& "lenNum" contains length of(or number of digits in) the input number.


;;*************PRINTING THE LENGTH OF THE NUMBER ABOVE begins:***************
;;Uncomment the portion below if necessary, otherwise you may just delete it.
;;If u uncomment this section, then prior to the beginning of this portion,
;;push ax,dx(if required), because this portion alters ax and dx values.
;;If u've pushed their values, then pop them up after this portion ends.
;;If altering ur ax,dx values don't create any problem for you,you don't need
;;to do push-pop for this portion. If you are not sure what to do,do push-pop.
;;
;lea dx,string_numLength
;mov ah,09h
;int 21h
;mov dx,lenNum
;add dx,48
;mov ah,02h
;int 21h
;**************PRINTING THE LENGTH OF THE NUMBER ABOVE ends*******************



;;************REPRINTING THE INPUT NUMBER IN DOS CONSOLE begins:**************
;;Uncomment this portion if u want to print back the input again in dos console.
;;If you uncomment this portion, then at first push ax,cx and dx(if required),
;;if u've pushed these values, then pop these values after this portion ends.
;;If altering ur ax,cx,dx values don't create any problem for u, u don't need
;;to do push-pop for this portion. If you are not sure what to do,do push-pop.
;;
;call newline_function
;lea dx,stringReprintInputNumber
;mov ah,09h
;int 21h
;xor dx,dx
;lea si,num1
;mov cx,lenNum
;reprinter:
;mov dl,[si]
;add dl,48
;mov ah,02h
;int 21h
;inc si
;loop reprinter
;;************REPRINTING THE INPUT NUMBER IN DOS CONSOLE ends******************

lea si,num1
;;please push ax,bx,cx,dx(if required) here as the function "recombiner" 
;;will alter their values. if you push these values here, then pop them
;;up just after the instruction "call recombiner" below.
call recombiner
;Now, "sum" contains the input number whose digits are in "num1".

;Enter your code here(if required):

exit:
mov ah,4ch
int 21h
MAIN ENDP

END MAIN
