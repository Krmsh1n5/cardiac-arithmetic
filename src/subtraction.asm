zero: .word 000
one: .word 001
nine_nine_nine: .word 999


carry: .word 000 ;our global variable - carry


local_num1: .word 000
local_num2: .word 000
local_sub: .word 000
return_point: .space 1

sub: LDA ra
	  STA return_point
	  LDA local_num1
	  ADD one ; adding one so if the local_num1 = local_num2 it doesn't go and set carry to 1
	  SUB local_num2
	  SUB carry ; subtracting carry from the previous time of calling the function
	  JAZ true ; path if x - y >= 0
	  SUB one
	  STA local_sub
	  LDA zero 
	  STA carry
	  LDA zero
	  JAZ return_point

      ; path if x - y < 0
true: LDA local_num2 ; as local_num2 > local_num1 we store local_num2 - local_num1 which we will use later
      SUB local_num1
      STA local_sub ; local_sub = ylo - xlo,   as  ylo > xlo 
      LDA one
      STA carry ; set carry to 1
      LDA zero
      JAZ return_point



xlo: .word 000 
xhi: .word 000
ylo: .word 000
yhi: .word 000

sub_xlo_ylo: .word 000
sub_xhi_yhi: .word 000

main: INP xlo
      INP xhi
      INP ylo
      INP yhi
      LDA xlo
      STA local_num1
      LDA ylo
      STA local_num2
      LDA zero
      JAZ sub
return1: LDA local_sub
        STA sub_xlo_ylo
        LDA carry ; checks if carry == 0
        JAZ carry0
        ; if carry == 1 then we subtract from 1000 the local_sub as xlo < ylo so
        LDA nine_nine_nine
        ADD one
        SUB sub_xlo_ylo
        STA sub_xlo_ylo ; stores the result of 1000 - (ylo-xlo)
carry0: LDA xhi
        STA local_num1
        LDA yhi
        STA local_num2
        LDA zero
        JAZ sub ; 2nd call
return2: LDA local_sub
	   STA sub_xhi_yhi
	   LDA carry ; again checks if carry == 0
	   JAZ smaller
         ; if carry == 1, this means that yhi > xhi  => xhi - yhi < 0
         ; this means that our 1st number was smaller than the 2nd number so we just output zeros
	   OUT zero
	   OUT zero
	   HRS
         ; otherwise if carry == 0, we simply output the result
smaller: OUT sub_xlo_ylo ;zlo
	   OUT sub_xhi_yhi ;zhi
         HRS

