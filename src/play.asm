SECTION "Playback", ROM0
StartPlayback::
    ; Set playback icon
    ld hl, ADDR_SYMBOL_B
    ld a, REC_SYMBOL_TILENO
    ld [hl], a

    ; Initialize system for playback
    ld a, KEY1F_PREPARE
    ld [rKEY1], a
    stop                          ; Double-speed mode
    ld hl, wRecordingBase         ; Pre-load RAM pointer
    ld a, LOW(rRP)
    ld c, a                       ; Load pointer for LDH [$ff00 + C]
    ld a, HIGH(_RAM)
    ld b, a                       ; Pre-load CP value for upper RAM boundary
                                  ; Higher performance due to register-based CP

    ; Play back RAM contents
.playbackLoop
    ld a, [hli]
    ldh [c], a
    ld a, h
    cp b
    jr nz, .playbackLoop

    ; Stop double speed mode
    ld a, KEY1F_PREPARE
    ld [rKEY1], a
    stop

    ; Re-enable interrupts
    call InitInterrupts

    jp MenuLoop