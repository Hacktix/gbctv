INCLUDE "inc/hardware.inc"
INCLUDE "src/ram.asm"
INCLUDE "src/data.asm"
INCLUDE "src/init.asm"
INCLUDE "src/functions.asm"
INCLUDE "src/rec.asm"
INCLUDE "src/play.asm"
INCLUDE "src/profile.asm"

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

    ; Enable SRAM
    ld a, $0a
    ld hl, $0000
    ld [hl], a

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

    ; Check A or B presses
    ld a, %11011111
    ld [rP1], a
    ld a, [rP1]
    bit 0, a
    jp z, StartRecording
    bit 1, a
    jp z, StartPlayback

    ; Check Profile Switch Cooldown
    ldh a, [hProfileCooldown]
    and a
    jr z, .noCooldown
    dec a
    ldh [hProfileCooldown], a
    jr .noLeft
.noCooldown

    ; Check Left or Right presses
    ld a, %11101111
    ld [rP1], a
    ld a, [rP1]
    bit 0, a
    jp nz, .noRight
    ld a, $01
    ld b, a
    call SwitchProfile
    jr .noLeft
.noRight
    bit 1, a
    jr nz, .noLeft
    ld a, $ff
    ld b, a
    call SwitchProfile
.noLeft

    jr MenuLoop