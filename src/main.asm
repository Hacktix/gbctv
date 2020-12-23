INCLUDE "inc/hardware.inc"
INCLUDE "inc/gbctv.inc"
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
    ; Load initial value of A into hInitialRegA
    ldh [hInitialRegA], a

    ; Wait for VBlank, disable LCD
	ldh a, [rLY]
	cp SCRN_Y
	jr c, Init
    xor a
    ld [rLCDC], a

    ; Load font tiles
    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
    call Memcpy

    ; Check if running on CGB, show error if not
    ld a, [hInitialRegA]
    cp BOOTUP_A_CGB
    jr z, .isCGB
    jp LockupNonCGB
.isCGB

    ; Initialize Palettes
    call InitPalettes

    ; Initialize Menu Text
    call InitMenu

    ; Enable SRAM
    ld a, CART_SRAM_ENABLE
    ld hl, rRAMG
    ld [hl], a

    ; Enable LCD
    ld a, LCDCF_ON | LCDCF_BGON
    ld [rLCDC], a

    ; Enable Interrupts
    call InitInterrupts

MenuLoop:
    halt

    ; Reset Buttons
    ld hl, ADDR_SYMBOL_A
    ld a, "A"
    ld [hl], a
    ld hl, ADDR_SYMBOL_B
    ld a, "B"
    ld [hl], a

    ; Check A or B presses
    ld a, P1F_GET_BTN
    ld [rP1], a
    ld a, [rP1]
    bit 0, a
    jp z, StartRecording
    bit 1, a
    jp z, StartPlayback

    ; Check Profile Switch Cooldown
    ldh a, [hProfileCooldown]
    and a
    jr z, .noCooldown            ; Go to D-Pad checking if zero
    dec a
    ldh [hProfileCooldown], a
    jr .noLeft
.noCooldown

    ; Check Left or Right presses
    ld a, P1F_GET_DPAD
    ld [rP1], a
    ld a, [rP1]

    bit 0, a
    jp nz, .noRight        ; If right D-Pad was pressed
    ld a, $01              ; Load value $01 into B
    ld b, a                ; To be added to profile number
    call SwitchProfile
    jr .noLeft             ; Skip check for left D-Pad
.noRight

    bit 1, a
    jr nz, .noLeft         ; If left D-Pad was pressed
    ld a, $ff              ; Load value $FF into B
    ld b, a                ; To be added to profile number
    call SwitchProfile
.noLeft

    jr MenuLoop



LockupNonCGB:
    ; Print error message to screen
    ld de, strNonCGB_L1
    ld hl, ADDR_NON_CGB_LABEL_L1
    call Strcpy
    ld de, strNonCGB_L2
    ld hl, ADDR_NON_CGB_LABEL_L2
    call Strcpy

    ; Enable LCD
    ld a, LCDCF_ON | LCDCF_BGON
    ld [rLCDC], a

    ; Lock up
    jr @