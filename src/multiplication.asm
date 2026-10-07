; Multiply two numbers by repeated addition.
; The result is num2 added to itself num1 times, accumulated through an
; indirect pointer (plocal_result) into the caller's result cell.

one:  .word 001
zero: .word 000

.at 10

local_num1: .word 000       ; multiplier  (how many times to add)
local_num2: .word 000       ; multiplicand (the value added each time)
counter: .word 000          ; working countdown from num1 to 0
return_point: .space 1
plocal_result: .word 000    ; pointer to the caller's result cell

multi: LDA ra               ; save the return address
       STA return_point
       LDA zero
       STI plocal_result    ; *result = 0
       LDA local_num1
       STA counter          ; counter = num1

while: LDA counter
       JAZ done             ; counter reached 0 -> finished
       LDI plocal_result
       ADD local_num2
       STI plocal_result    ; *result += num2
       LDA counter
       SUB one
       STA counter          ; counter--
       LDA zero
       JAZ while            ; unconditional: test the counter again

done:  LDA zero
       JAZ return_point     ; return to the caller


main_num1: .space 1
main_num2: .space 1
main_result: .word 000
pmain_result: .word main_result

.at 50
main: INP main_num1
      INP main_num2
      LDA main_num1
      STA local_num1
      LDA main_num2
      STA local_num2
      LDA pmain_result
      STA plocal_result     ; point the routine at main_result
      LDA zero
      JAZ multi             ; call multiply
      OUT main_result
      HRS
