SECTION "Playback", ROM0
StartPlayback::
    ; Set playback icon
    ld hl, $98e2
    ld a, $1f
    ld [hl], a

    ; Initialize system for playback
    ld a, 1
    ld [rKEY1], a
    stop                          ; Double-speed mode
    ld hl, wRecordingBase         ; Pre-load RAM pointer
    ld a, $56
    ld c, a                       ; Load pointer for LDH [$ff00 + C]
    ld a, $c0
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
    ld a, 1
    ld [rKEY1], a
    stop

    ; Re-enable interrupts
    call InitInterrupts

    jp MenuLoop