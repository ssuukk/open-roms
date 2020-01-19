// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - handling the pilot
//

// Injest the pilot - series of short pulses. According to http://sidpreservation.6581.org/tape-format/
// it consist of the following number of pulses:
// - $6A00 for header
// - $1A00 for data and seq block header
// - $4F for repeated header/data


#if CONFIG_TAPE_NORMAL


// XXX in tape_normal_get_pilot_header also try to detect turbo

tape_normal_get_pilot_header:          // entry point, reset calibration, require 128x $40 pulses

	// Reading the pilot header is the first action performed,
	// thus start by setting default timings, as measured during
	// VICE test

	lda #$7D
	sta __normal_time_M                // __normal_time_S will be set within the pilot
	lda #$91
	sta __pulse_threshold
	lda #$67
	sta __pulse_threshold_ML

	lda #$80

	skip_2_bytes_trash_nvz

	// FALLTROUGH

tape_normal_get_pilot_data:            // entry point, require 4x $40 pulses

	lda #$04

	skip_2_bytes_trash_nvz

	// FALLTROUGH

tape_normal_get_pilot_short:           // entry point, require 1x $40 pulses

	lda #$01

	// FALLTROUGH

tape_normal_get_pilot_common:

	sta FSBLK

	lda #$0B
	sta VIC_EXTCOL

	// FALLTROUGH

tape_normal_get_pilot_common_restart:

	lda FSBLK
	sta ROPRTY

	// FALLTROUGH

tape_normal_get_pilot_common_loop_outer:

	ldy #$40

	// FALLTROUGH

tape_normal_get_pilot_common_loop_inner:

	jsr tape_common_get_pulse
	// XXX check for short pulses of turbo here
	bcc tape_normal_get_pilot_common_restart     // not a pilot - try again
	
	jsr tape_normal_calibrate_during_pilot

	dey
	bne tape_normal_get_pilot_common_loop_inner

	dec ROPRTY
	bne tape_normal_get_pilot_common_loop_outer

	rts


#endif
