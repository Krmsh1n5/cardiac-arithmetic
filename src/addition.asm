zero: .word 000
one: .word 001
nine_nine_nine: .word 999


carry: .word 000 ;our global variable - carry


local_num1: .word 000
local_num2: .word 000
local_modulo_sum: .word 000 ; will store num1+num2 mod 1000
return_point: .space 1

add: LDA ra
	  STA return_point
	  LDA local_num1
	  ADD local_num2
	  ADD carry ; we add carry from the previous addition
	  SUB nine_nine_nine ; subtract 999 to find if the number is >1000
	  JAZ true 
        ; path if number >= 1000
	  SUB one ; previously subtracted 999 now subtract 1 to get mod 1000 of num1+num2 in our accumulator
	  STA local_modulo_sum
	  LDA one
	  STA carry ; sets the carry to one
	  LDA zero
	  JAZ return_point
true: LDA local_num1 ; path if the number is less than 1000
      ADD local_num2
      ADD carry  
      STA local_modulo_sum
      LDA zero
      STA carry ;reset carry to zero
      LDA zero
      JAZ return_point



xlo: .word 000 ; last 3 digits of x
xhi: .word 000 ; first 3 digits of x
ylo: .word 000 ; last 3 digits of y
yhi: .word 000 ; first 3 digits of y

modulo_xlo_ylo: .word 000 ; (xlo+ylo) % 1000
modulo_xhi_yhi: .word 000 ; (xhi+yhi) % 1000

main: INP xlo
      INP xhi
      INP ylo
      INP yhi
      ; firstly we pass last 3 digits of both x and y to the add function
      LDA xlo
      STA local_num1
      LDA ylo
      STA local_num2
      LDA zero
      JAZ add
return1: LDA local_modulo_sum
        STA modulo_xlo_ylo
        ; pass the first 3 digits of x and y to the add function
        LDA xhi 
        STA local_num1
        LDA yhi
        STA local_num2
        LDA zero
        JAZ add ;2nd call
return2: LDA local_modulo_sum
	   STA modulo_xhi_yhi
	   OUT modulo_xlo_ylo ; zlo
	   OUT modulo_xhi_yhi ; zhi
	   OUT carry ; I additionally output the carry to represent the full number
         HRS

