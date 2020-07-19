// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_cmp_varnam:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Compare variable name

	ldy #$00
	lda (VARPNT),y

	cmp VARNAM+0
	bne !+

	iny
	lda (VARPNT),y
	cmp VARNAM+1
!:
	// Restore default memory mapping

	jmp remap_BASIC_preserve_P

#endif
