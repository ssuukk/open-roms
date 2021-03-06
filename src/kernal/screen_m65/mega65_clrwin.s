;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


; XXX deduplicate pointer manipulation, see M65_CLRSCR
; XXX consider using DMAgic for this - FILL command

M65_CLRWIN:

	; Clear additional attributes from the color code

	jsr m65_screen_clear_colorattr

	; Check if windowed mode; if not, go to M65_CLRSCR

	lda M65_SCRWINMODE
	+bpl m65_clrscr_takeover

	; To clear the window, two zeropage long pointers will be used:
	; - M65_LPNT_SCR  for screen memory
	; - M65_LPNT_KERN for colour memory (starts from $FF80000) ; XXX preserve this on stack, restore afterwards

	; First initialize both pointers

	; XXX use m65_helper_scrlpnt_color and m65_helper_scrlpnt_to_screen instead

	clc
	lda M65_COLVIEW+0
	adc M65_SCRBASE+0
	sta M65_LPNT_SCR+0
	lda M65_COLVIEW+1
	adc M65_SCRBASE+1
	sta M65_LPNT_SCR+1
	lda M65_SCRSEG+0
	sta M65_LPNT_SCR+2
	lda M65_SCRSEG+1
	sta M65_LPNT_SCR+3

	lda M65_COLVIEW+0
	sta M65_LPNT_KERN+0
	lda M65_COLVIEW+1
	sta M65_LPNT_KERN+1
	; XXX deduplicate part below with M65_CLRSCR
	lda #$F8
	sta M65_LPNT_KERN+2
	lda #$0F
	sta M65_LPNT_KERN+3

    ; Go trough all the rows

    phz
    ldy #$00

    ; FALLTROUGH

m65_clrwin_loop:

	; Check if .Y cordinate is not below the window

	cpy M65_TXTWIN_Y0
	bcc m65_clrwin_loop_next                     ; branch if we should skip this row

	; Clear the row

	ldz M65_TXTWIN_X0
@1:
	lda #$20
	sta [M65_LPNT_SCR],z
	lda COLOR
	sta [M65_LPNT_KERN],z
	inz
	cpz M65_TXTWIN_X1
	bne @1

	; FALLTROUGH

m65_clrwin_loop_next:

	; Increment M65_LPNT_SCR and M65_LPNT_KERN by the logical row length (always 80 = $50)

	clc
	lda #$50
	adc M65_LPNT_SCR+0
	sta M65_LPNT_SCR+0
	bcc @2
	inc M65_LPNT_SCR+1
@2:
	clc
	lda #$50
	adc M65_LPNT_KERN+0
	sta M65_LPNT_KERN+0
	bcc @3
	inc M65_LPNT_KERN+1
@3:
	; Increment row counter, check if new row is valid

	iny
	cpy M65_TXTWIN_Y1
	bne m65_clrwin_loop
    plz

    ; Set screen variables

	; XXX implement this

	rts
