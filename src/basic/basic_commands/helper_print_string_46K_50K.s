;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routine below banks out the main BASIC ROM!

!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_print_string:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Print the string

	ldy #$00
@1:
	cpy __FAC1 + 0
	+beq remap_BASIC                   ; branch if end of the string
	lda (__FAC1 + 1), y
	jsr JCHROUT
	iny
	bpl @1
}
