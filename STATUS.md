# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s (many of them are [configurable](CONFIG.md)):

* improved keyboard scanning, supports anti-ghosting and is resistant to joystick interference (one variant even supports multi-keyy rollover)
* joystick can be used to move text cursor
* uses RAM under ROM and I/O: 61438 bytes free
* cold/warm start silences multiple SID chips - all $D4xx and $D5xx addresses
* wark start due to BRK prints out the instruction address
* extended `LOAD` command
    * start/end addresses are displayed, in the Final cartridge style
    * command with just the file name tries to use the last device if it's number seems sane; otherwise uses 8
    * secondary address over 255 is considered a start address
* DOS wedge (direct mode only) - `@<drive_number>`, `@<command>`, `@$`, `@$<params>`, `@`

NOTE: extra features and their syntax can change in the future!


# Features missing


The following ROM features are currently missing:

* most BASIC commands
* BASIC variables
* BASIC expression parsing
* floating point routines
* tape support
* RS-232 support
* breaking Kernal routines with RUN/STOP key
* NMI handling is incomplete


# API status


Status of the various APIs and variables from the original ROMs


## Low memory locations (pages 0 - 3)


For the current status of the low memory location implementation andd usage check [this file](c64/aliases/,aliases_ram_lowmem.s). NOTE: available vector to certain routine does not mean that this routine is fully implemented!


## BASIC

### Official BASIC routines

Note: vectors at `$0300` are not supported yet - for now only the locations below can be used!

<br />

| Entry     | Unofficial | Name       | Status   |  Remarks                                           |
| :-------: | :--------: | :--------- | :------: | :------------------------------------------------: |
| `($0003)` |            | `ADRAY1`   | NOT DONE |                                                    |
| `($0005)` |            | `ADRAY2`   | NOT DONE |                                                    |
| `(00300)` | `$E38B`    | `ERROR`    | NOT DONE |                                                    |
| `(00302)` | `$A483`    | `MAIN`     | NOT DONE | some implementation exists, but not connected here |
| `(00304)` | `$A57C`    | `CHRNCH`   | NOT DONE |                                                    |
| `(00306)` | `$A71A`    | `QPLOP`    | NOT DONE | some implementation exists, but not connected here |
| `(00308)` | `$A7E4`    | `GONE`     | NOT DONE | some implementation exists, but not connected here |
| `(0030A)` | `$AE86`    | `EVAL`     | NOT DONE | some implementation exists, but not connected here |
| `($A000)` | `$E394`    | cold start | PARTIAL  |                                                    |
| `($A002)` | `$E3B7`    | warm start | PARTIAL  |                                                    |

<br />

### Unofficial BASIC routines/locations

Not all of them - only these we want to have implemented.

<br />

| Address   | Name         | Status   |  Remarks                                           |
| :-------: | :----------- | :------: | :------------------------------------------------: |
| `$A004`   | revision str | DONE     |                                                    |
| `$A408`   | REASON       | NOT DONE |                                                    |
| `$A453`   | (unknown)    | NOT DONE |                                                    |
| `$A533`   | LINKPRG      | DONE     |                                                    |
| `$A644`   | new          | NOT DONE |                                                    |
| `$A659`   | set txt ptr  | NOT DONE |                                                    |
| `$A68E`   | RUNC         | DONE     |                                                    |
| `$A7AE`   | NEWSTT       | PARTIAL  | redirected to RUN command                          |
| `$AB1E`   | STROUT       | DONE     |                                                    |
| `$BDCD`   | LINPRT       | DONE     | temporary implementation                           |
| `$E3BF`   | INIT         | NOT DONE |                                                    |
| `$E422`   | INITMSG      | DONE     |                                                    |
| `$E453`   | RVECT        | NOT DONE |                                                    |

<br />

## Kernal

### Official Kernal routines

NOTE: Even the 'DONE' routines won't support features described as missing in one of the previous chapters!

<br />

| Address   | Unofficial | Name        | Status   |  Remarks                                             |
| :-------: | :--------: | :---------- | :------: | :--------------------------------------------------: |
| `($028F)` |            | `KEYLOG`    | DONE     |                                                      |
| `$FF81`   | `$FF5B`    | `CINT`      | DONE     |                                                      |
| `$FF84`   | `$FDA3`    | `IOINIT`    | PARTIAL  | CIA initialization might be incomplete               |
| `$FF87`   | `$FD50`    | `RAMTAS`    | PARTIAL  | probably shouldn't touch VIC and CIA's               |
| `$FF8A`   | `$FD15`    | `RESTOR`    | DONE     |                                                      |
| `$FF8D`   | `$FD1A`    | `VECTOR`    | DONE     |                                                      |
| `$FF90`   |            | `SETMSG`    | DONE     |                                                      |
| `$FF93`   |            | `SECOND`    | DONE     |                                                      |
| `$FF96`   |            | `TKSA`      | DONE     |                                                      |
| `$FF99`   | `$FE25`    | `MEMTOP`    | DONE     |                                                      |
| `$FF9C`   |            | `MEMBOT`    | DONE     |                                                      |
| `$FF9F`   |            | `SCNKEY`    | DONE     |                                                      |
| `$FFA2`   |            | `SETTMO`    | DONE     |                                                      |
| `$FFA5`   |            | `ACPTR`     | DONE     |                                                      |
| `$FFA8`   |            | `CIOUT`     | DONE     |                                                      |
| `$FFAB`   |            | `UNTLK`     | DONE     |                                                      |
| `$FFAE`   |            | `UNLSN`     | DONE     |                                                      |
| `$FFB1`   |            | `LISTEN`    | DONE     |                                                      |
| `$FFB4`   |            | `TALK`      | DONE     |                                                      |
| `$FFB7`   |            | `READST`    | DONE     |                                                      |
| `$FFBA`   |            | `SETFLS`    | DONE     |                                                      |
| `$FFBD`   |            | `SETNAM`    | DONE     |                                                      |
| `$FFC0`   | `$F34A`    | `OPEN`      | DONE     |                                                      |
| `$FFC3`   | `$F291`    | `CLOSE`     | DONE     |                                                      |
| `$FFC6`   | `$F20E`    | `CHKIN`     | DONE     |                                                      |
| `$FFC9`   | `$F250`    | `CKOUT`     | PARTIAL  |                                                      |
| `$FFCC`   | `$F333`    | `CLRCHN`    | DONE     |                                                      |
| `$FFCF`   | `$F157`    | `CHRIN`     | PARTIAL  |                                                      |
| `$FFD2`   | `$F1CA`    | `CHROUT`    | PARTIAL  |                                                      |
| `$FFD5`   | `$F49E`    | `LOAD`      | PARTIAL  | not yet clear what's this entry doing                |
| `($0330)` | `$F4A5`    | `LOAD`      | PARTIAL  | no VERIFY support, no STOP key, check $F49E addr     |
| `$FFD8`   | `$F5DD`    | `SAVE`      | NOT DONE |                                                      |
| `($0332)` | `$F5ED`    | `SAVE`      | NOT DONE |                                                      |
| `$FFDB`   |            | `SETTIM`    | DONE     |                                                      |
| `$FFDE`   |            | `RDTIM`     | DONE     |                                                      |
| `$FFE1`   | `$F6ED`    | `STOP`      | DONE     |                                                      |
| `$FFE4`   | `$F13E`    | `GETIN`     | PARTIAL  | only keyboard supported                              |
| `$FFE7`   | `$F32F`    | `CLALL`     | DONE     |                                                      |
| `$FFEA`   |            | `UDTIM`     | DONE     |                                                      |
| `$FFED`   |            | `SCREEN`    | DONE     |                                                      |
| `$FFF0`   | `$E50A`    | `PLOT`      | DONE     |                                                      |
| `$FFF3`   |            | `IOBASE`    | DONE     |                                                      |
| `($FFFA)` |            | NMI vec     | PARTIAL  |                                                      |
| `($FFFC)` | `$FCE2`    | RESET vec   | PARTIAL  |                                                      |
| `($FFFE)` |            | IRQ/BRK vec | PARTIAL  |                                                      |

<br />

### Unofficial Kernal routines/locations

Not all of them - only these we want to have implemented.

<br />

| Address   | Name                         | Status   |  Remarks                                           |
| :-------: | :--------------------------- | :------: | :------------------------------------------------: |
| `$E518`   | legacy part of CINT          | DONE     |                                                    |
| `$E51B`   | init screen keyboard, no VIC | DONE     |                                                    |
| `$E544`   | clear screen                 | DONE     |                                                    |
| `$E50C`   | set cursor position          | PARTIAL  |                                                    |
| `$E566`   | home cursor                  | NOT DONE |                                                    |
| `$E5A0`   | setup VIC II & IO            | DONE     |                                                    |
| `$E6B6`   | advance cursor               | NOT DONE |                                                    |
| `$E701`   | previous line                | NOT DONE |                                                    |
| `$E716`   | screen CHROUT                | NOT DONE |                                                    |
| `$E8EA`   | scroll line                  | NOT DONE |                                                    |
| `$E96C`   | insert line on top           | NOT DONE |                                                    |
| `$E9FF`   | clear line                   | NOT DONE |                                                    |
| `$EA31`   | default IRQ                  | PARTIAL  |                                                    |
| `$EA7E`   | ack CIA1 + below             | DONE     |                                                    |
| `$EA81`   | ret from IRQ/NMI             | DONE     |                                                    |
| `$F142`   | get key from buffer          | DONE     |                                                    |
| `$F646`   | IEC close                    | NOT DONE |                                                    |
| `$FD30`   | default vectors              | DONE     |                                                    |
| `$FD90`   | (unknown)                    | NOT DONE |                                                    |
| `$FD90`   | (unknown)                    | NOT DONE |                                                    |
| `$FE2D`   | memtop set part              | DONE     |                                                    |
| `$FE47`   | default NMI                  | PARTIAL  |                                                    |
| `$FE66`   | default BRK                  | DONE     |                                                    |
| `$FF80`   | revision byte                | DONE     |                                                    |

<br />