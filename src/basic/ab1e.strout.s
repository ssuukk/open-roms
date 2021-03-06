;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE-FLOAT
;; #LAYOUT# *   *       #IGNORE

; Print string at $YYAA
; Computes Mapping the 64 p101

; print string routine

STROUT:

	; Setup pointer
	sty FRESPC+1
	sta FRESPC+0
	
	+phx_trash_a

	; Get offset ready
	ldy #$00
@1:
	; Save Y in X, since X is preserved by chrout, but Y is not
	tya
	tax

	lda (FRESPC),y
	beq @2

	jsr JCHROUT

	txa
	tay

	iny
	bne @1
@2:
	pla ; XXX can we use plx_trash_a here?
	tax
	rts
