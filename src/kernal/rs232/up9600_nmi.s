;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 NMI handler part
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


up9600_nmi:
	; XXX integrate with NMI handler

	pha
	bit CIA2_ICR ; $DD0D; check if CIA caused the interrupt
	bpl NMIDOBI2; NO STARTBIT RECEIVED, THEN SKIP
	lda #$13
	sta CIA2_CRB ; $DD0F; START TIMER B (FORCED RELOAD, SIGNAL AT PB7)
	sta CIA2_ICR ; $DD0D; DISABLE TIMER AND FLAG INTERRUPTS
	lda #<NMIBYTRY; ON NEXT NMI CALL NMIBYTRY
	sta NMIVECT; (TRIGGERED BY SDR FULL)
	lda #>NMIBYTRY
	sta NMIVECT+1
NMIDOBI2:
	pla; IGNORE, IF NMI WAS TRIGGERED BY RESTORE-KEY
	rti
NMIBYTRY:
	pha
	bit CIA2_ICR ; $DD0D; CHECK BIT 7 (SDR FULL PRINT)
	bpl NMIDOBI2; SDR NOT FULL, THEN SKIP (EG. RESTORE-KEY)
	lda #$92
	sta CIA2_CRB ; $DD0F; STOP TIMER B (KEEP SIGNALLING AT PB7!)
	sta CIA2_ICR ; $DD0D; ENABLE FLAG (AND TIMER) INTERRUPTS
	lda #<NMIDOBIT; ON NEXT NMI CALL NMIDOBIT
	sta NMIVECT; (TRIGGERED BY A STARTBIT)
	lda #>NMIDOBIT
	sta NMIVECT+1
	+phx_trash_a
	+phy_trash_a
	lda CIA2_SDR ; $DD0C; READ SDR (BIT0=DATABIT7,...,BIT7=DATABIT0)
	cmp #128; MOVE BIT7 INTO CARRY-FLAG
	and #127
	tax
	lda REVTAB,X; READ DATABITS 1-7 FROM LOOKUP TABLE
	adc #0; ADD DATABIT0
	ldy RIDBE; AND WRITE IT INTO THE RECEIVE BUFFER
	sta (RIBUF),Y
	iny
	sty RIDBE
	sec;;START BUFFER FULL CHK
	tya
	sbc RIDBS
	cmp #200
	bcc NMIBYTR2
	lda CIA2_PRB ; $DD01;; MORE THAN 200 BYTES IN THE RECEIVE BUFFER
	and #$FD;; THEN DISABLE RTS
	sta CIA2_PRB ; $DD01
NMIBYTR2:
	+ply_trash_a
	+plx_trash_a
	pla
	rti
}
