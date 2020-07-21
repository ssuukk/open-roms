// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Tokenise a line of BASIC stored at $0200
//
// Input:
// - length in __tokenise_work1
//


tokenise_line:

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__tokenise_line
	jmp     map_NORMAL

#else

	// Reuse the CPU stack - addresses above $100 are used by 'tk_pack.s'

	.label tk__offset       = $100               // offset into string
	.label tk__length       = __tokenise_work1   // length of the raw string

	// Initialize variables

	lda #$00
	sta tk__offset

	// Terminate input string with $00

	// XXX do we need this?
	ldx tk__length
	sta BUF, x

	// FALLTROUGH

tokenise_line_loop:

	// Check if we have reached end of the line

	lda tk__offset
	cmp tk__length
	beq tokenise_line_done

	// Check for some special characters

	ldx tk__offset
	lda BUF, x

	cmp #$22
	beq tokenise_line_quote

	cmp #$DE
	beq tokenise_line_pi

	cmp #$3F
	beq tokenise_line_question_mark              // shortcut for PRINT command

	// Try to tokenise

	jsr tk_pack
!:
	lda tk__len_unpacked
	beq tokenise_line_char                       // branch if attempt to tokenise failed

	// Check for BASIC V2 tokens

	lda #<packed_freq_keywords_V2
	sta FRESPC+0
	lda #>packed_freq_keywords_V2
	sta FRESPC+1

	jsr tk_search
	bcc tokenise_line_keyword_V2                 // branch if keyword identified

	// Check for extended tokens

	lda #<packed_freq_keywords_01
	sta FRESPC+0
	lda #>packed_freq_keywords_01
	sta FRESPC+1

	jsr tk_search
	bcc tokenise_line_keyword_01                 // branch if keyword identified

#if !HAS_SMALL_BASIC

	lda #<packed_freq_keywords_02
	sta FRESPC+0
	lda #>packed_freq_keywords_02
	sta FRESPC+1

	jsr tk_search
	bcc tokenise_line_keyword_02                 // branch if keyword identified

#endif

	// Shorten packed keyword candidate and try again

	jsr tk_shorten

	jmp_8 !-

tokenise_line_keyword_V2:

	// .X contains a token ID, starting from 0

	txa
	pha                                          // store the token on the stack, we will need it for REM support

	// Store the token

	ldx tk__offset
	clc
	adc #$80
	sta BUF, x

	// Cut away unnecessary bytes
	jsr tk_cut_away_1

	// Special handling for REM command - after this one nothing more should be tokenised

	pla
	cmp #$0F                                     // REM token index
	bne tokenise_line_loop

	// FALLTROUGH

tokenise_line_done:

	// Quit

	rts

tokenise_line_quote:

	// For the quote, we advance without tokenizing, until the next quote is found

	inc tk__offset
	ldx tk__offset

	lda BUF, x
	beq tokenise_line_done

	cmp #$22
	beq tokenise_line_char
	bne tokenise_line_quote                      // branch always

tokenise_line_pi:

	lda #$FF                                     // token for PI
	skip_2_bytes_trash_nvz

	// FALLTROUGH

tokenise_line_question_mark:

	lda #$99                                     // token for PRINT
	sta BUF, x

	// FALLTROUGH

tokenise_line_char:

	inc tk__offset
	jmp tokenise_line_loop


// Support for extended keyword lists

#if !HAS_SMALL_BASIC

tokenise_line_keyword_02:

	// Store the token list index

	lda #$02
	skip_2_bytes_trash_nvz

	// FALLTROUGH

#endif

tokenise_line_keyword_01:

	// Store the token list index

	lda #$01

	ldy tk__offset
	sta BUF, y

	// Store the sub-token itself

	inx
	txa
	iny
	sty tk__offset
	sta BUF, y

	// Cut away unnecessary bytes

	jsr tk_cut_away_2
	jmp tokenise_line_loop

#endif // ROM layout
