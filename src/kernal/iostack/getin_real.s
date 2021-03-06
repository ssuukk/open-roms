;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 283
; - [CM64] Computes Mapping the Commodore 64 - page 227/228
;
; CPU registers that has to be preserved (see [RG64]): for RS-232: .X, .Y
;


getin_real:

	; Determine the device number
	lda DFLTN

	; Try $00 - keyboard
	+beq getin_keyboard

!ifdef HAS_RS232 {

	; Try $02 - RS-232
	cmp #$02
	+beq getin_rs232
}

	jmp chrin_getin
