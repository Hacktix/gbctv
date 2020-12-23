SECTION "Initialization", ROM0

;------------------------------------------------------------------------
; Initializes the CGB color palette.
; TODO: Optimize this.
;------------------------------------------------------------------------
InitPalettes::
    ; Initializing BGP0
    ld a, BCPSF_AUTOINC
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

;------------------------------------------------------------------------
; Initializes the program for displaying main menu by writing strings,
; to VRAM0, setting palettes in VRAM1 and initializing HRAM variables.
;------------------------------------------------------------------------
InitMenu::
    ; Write Strings to screen
    ld de, strTitle
    ld hl, ADDR_TITLE_LABEL
    call Strcpy
    ld de, strPressA
    ld hl, ADDR_REC_LABEL
    call Strcpy
    ld de, strPressB
    ld hl, ADDR_PLAY_LABEL
    call Strcpy
    ld de, strProfile
    ld hl, ADDR_PROFILE_LABEL
    call Strcpy

    ; Set palettes in VRAM1
    ld a, 1
    ld [rVBK], a
    ld hl, ADDR_REC_LABEL
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld hl, ADDR_PLAY_LABEL
    ld a, 2
    ld [hli], a
    ld [hli], a
    ld [hli], a
    xor a
    ld [rVBK], a

    ; Initialize Profile Selection
    ldh [hSelectedProfile], a
    ldh [hProfileCooldown], a

    ret

;------------------------------------------------------------------------
; Clears the IF register to clear any pending interrupts and enables
; VBlank interrupts.
;------------------------------------------------------------------------
InitInterrupts::
    xor a
    ld [rIF], a
    ld a, IEF_VBLANK
    ld [rIE], a
    ei 
    ret