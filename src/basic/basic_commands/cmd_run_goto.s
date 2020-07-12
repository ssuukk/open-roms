// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_run:

	// RUN clears all variables
	jsr do_clr

cmd_goto:

	// XXX optimize this: deduplicate last part (and init_oldtxt) with load/verify,
	// if line number greater than current line - find line backwards

	// Disable Kernal messages
	lda #$00
	jsr JSETMSG

	// Reset line pointer to first line of program.
	jsr init_oldtxt

	jsr is_end_of_statement
	bcs !+

	jsr fetch_line_number
	bcs_16 do_SYNTAX_error
	jsr find_line
	bcc !+
	// Line does not exist, so report error
	jmp do_UNDEFD_STATEMENT_error
!:
	// Run it!
	
	pha
	pha
	jmp execute_line
