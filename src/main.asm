INCLUDE "inc/hardware.inc"
INCLUDE "src/ram.asm"
INCLUDE "src/data.asm"
INCLUDE "src/init.asm"
INCLUDE "src/functions.asm"
INCLUDE "src/rec.asm"
INCLUDE "src/play.asm"

SECTION "Vectors", ROM0[$0]
    ds $40 - @

VBlankVector::
    reti

    ds $100 - @

SECTION "Test", ROM0[$100]
    di
    jp Init
    ds $150 - @

Init::
    ; Wait for VBlank, disable LCD
	ldh a, [rLY]
	cp SCRN_Y
	jr c, Init
    xor a
    ld [rLCDC], a

    ; Initialize Palettes
    call InitPalettes

    ; Load font tiles
    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
    call Memcpy

    ; Initialize Menu Text
    call InitMenu

    ; Initialize Joypad
    ld a, %11011111
    ld [rP1], a

    ; Enable LCD
    ld a, %10000001
    ld [rLCDC], a

    ; Enable Interrupts
    call InitInterrupts

MenuLoop:
    halt

    ; Reset Buttons
    ld hl, $98a2
    ld a, "A"
    ld [hl], a
    ld hl, $98e2
    ld a, "B"
    ld [hl], a

    ld a, [rP1]
    bit 0, a
    jp z, StartRecording
    bit 1, a
    jp z, StartPlayback

    jr MenuLoop