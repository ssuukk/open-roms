;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_old:

	; First make sure we are in direct mode

	ldx CURLIN+1
	inx
	+bne do_DIRECT_MODE_ONLY_error

	; Now try to restore program linkage and VARTAB

	ldy #$01
	tya
	sta (TXTTAB),y

	jsr update_LINKPRG_VARTAB_do_clr

	; Quit

	jmp end_of_program
