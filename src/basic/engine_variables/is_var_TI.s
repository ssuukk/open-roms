;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


is_var_TI:

	; Always start with VARNAM+1, there is a sligtly bigger chance it won't match

	lda VARNAM+1
	cmp #$49       ; 'I'
	bne @1

	lda VARNAM+0
	cmp #$54       ; 'T'
@1:
	rts
