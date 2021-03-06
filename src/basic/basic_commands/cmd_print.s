;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_print:

	; First check if we have anything to print

	jsr is_end_of_statement
	bcs cmd_print_new_line_done

	jsr fetch_character
	cmp #$3B                           ; semicolon
	beq cmd_print_done

	; FALLTROUGH

cmd_print_loop:

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}

	; FALLTROUGH

cmd_print_after_comma:

	; Now evaluate the expression and check what to print

	jsr tmpstr_free_all
	jsr FRMEVL
	lda VALTYP
	bpl cmd_print_float

	; FALLTROUGH

cmd_print_string:

	; Print a string value

!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

	jsr helper_print_string
	+bra cmd_print_next_arg

} else { ; CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_60K

	ldy #$00
@1:
	cpy __FAC1 + 0
	beq cmd_print_next_arg

!ifdef CONFIG_MEMORY_MODEL_60K { 
	ldx #<(__FAC1 + 1)
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (__FAC1 + 1), y
}

	jsr JCHROUT
	iny
	bpl @1
}

cmd_print_float:

	; XXX probably we should also check INTFLG here
	; XXX provide implementation

	jmp do_NOT_IMPLEMENTED_error

	; FALLTROUGH

cmd_print_next_arg:

	; Look for the next argument

	jsr is_end_of_statement
	bcs cmd_print_new_line_done

	cmp #$2C                           ; comma    XXX on C64 behavior is more complicated, fix it
	beq cmd_print_after_comma
	cmp #$3B                           ; semicolon
	beq cmd_print_done
	bne cmd_print_loop

cmd_print_new_line_done:

	jsr print_return

	; FALLTROUGH

cmd_print_done:

	; Execute next statement

	rts
