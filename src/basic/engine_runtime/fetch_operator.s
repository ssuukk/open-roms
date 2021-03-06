;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Fetches an operator - for the expression parser
;
; Note: does not recognize unary operators
;


fetch_operator: ; XXX change the operator code to start from 0

	; Retrieve the next character

	jsr fetch_character

	; Check if within range

	sec
	sbc #$AA
	bcc fetch_operator_failed             ; branch if below 0

	cmp #$0A
	bcs fetch_operator_failed             ; branch if $0A or greater

	; Now we have to recognize '>=', '<=' and '<>' operators

	cmp #$07
	beq fetch_operator_try_gteq

	cmp #$09
	beq fetch_operator_try_lteq_neq

	; FALLTROUGH

fetch_operator_success:

	clc
	rts

fetch_operator_failed:

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}

	sec
	rts


fetch_operator_try_gteq:

	; Here we distinguish between '>' and '>='

	jsr fetch_character
	cmp #$B2                           ; '='
	beq @1

	; This is a '>'

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}
	lda #$07
	bne fetch_operator_success         ; branch always
@1:
	; This is a '>='

	lda #$0A
	bne fetch_operator_success         ; branch always


fetch_operator_try_lteq_neq:

	; Here we distinguish between '<', '<=', and '<>'

	jsr fetch_character
	cmp #$B2                           ; '='
	beq @2
	cmp #$B1                           ; '>'
	beq @3

	; This is a '<'

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}
	lda #$09
	bne fetch_operator_success         ; branch always
@2:
	; This is a '<='

	lda #$0B
	bne fetch_operator_success         ; branch always
@3:
	; This is a '<>'

	lda #$0C
	bne fetch_operator_success         ; branch always
