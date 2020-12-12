SECTION "Initialization", ROM0
InitPalettes::
    ; Initializing BGP0
    ld a, %10000000
    ld [rBCPS], a
    xor a
    ld [rBCPD], a
    ld [rBCPD], a
    or $ff
    ld [rBCPD], a
    ld [rBCPD], a
    ld [rBCPD], a
    ld [rBCPD], a
    ld [rBCPD], a
    ld [rBCPD], a

    ; Initializing BGP1
    xor a
    ld [rBCPD], a
    ld [rBCPD], a
    or $1f
    ld [rBCPD], a
    xor a
    ld [rBCPD], a
    or $1f
    ld [rBCPD], a
    xor a
    ld [rBCPD], a
    or $1f
    ld [rBCPD], a
    xor a
    ld [rBCPD], a

    ; Initializing BGP2
    xor a
    ld [rBCPD], a
    ld [rBCPD], a
    ld a, $e0
    ld [rBCPD], a
    ld a, $03
    ld [rBCPD], a
    ld a, $e0
    ld [rBCPD], a
    ld a, $03
    ld [rBCPD], a
    ld a, $e0
    ld [rBCPD], a
    ld a, $03
    ld [rBCPD], a

    ret

InitMenu::
    ; Write Strings to screen
    ld de, strTitle
    ld hl, $9822
    call Strcpy
    ld de, strPressA
    ld hl, $98a1
    call Strcpy
    ld de, strPressB
    ld hl, $98e1
    call Strcpy

    ; Set palettes in VRAM1
    ld a, 1
    ld [rVBK], a
    ld hl, $98a1
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld hl, $98e1
    ld a, 2
    ld [hli], a
    ld [hli], a
    ld [hli], a
    xor a
    ld [rVBK], a

    ret

InitInterrupts::
    xor a
    ld [rIF], a
    ld a, 1
    ld [rIE], a
    ei 
    ret