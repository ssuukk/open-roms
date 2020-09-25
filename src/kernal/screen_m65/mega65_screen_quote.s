;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; CHROUT routine - screen support, control codes in quote mode, MEGA65 native mode version
;


m65_chrout_screen_quote:

	; Low control codes are just +$80
	clc
	adc #$80

	; If it overflowed, then it is a high control code,
	; so we need to make it be $80 + $40 + char
	; as we will have flipped back to just $00 + char, we should
	; now add $c0 if C is set from overflow
	bcc @1
	adc #$BF    ; C=1, so adding $BF + C = add $C0
@1:
	jmp m65_chrout_screen_literal
