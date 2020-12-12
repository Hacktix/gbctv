SECTION "Recording", ROM0
StartRecording::
    ; Disable Interrupts
    di

    ; Set recording icon
    ld hl, $98a2
    ld a, $1f
    ld [hl], a

    ; Initialize IR reading
    ld a, %11000000
    ld [rRP], a

    ; Wait for first signal to arrive
.recordWaitLoop
    ld a, [rRP]
    bit 1, a
    jp nz, .recordWaitLoop

    ; Initialize system for high-speed IR reading
    ld a, 1
    ld [rKEY1], a
    stop                          ; Double-speed mode
    ld hl, wRecordingBase         ; Pre-load RAM pointer
    ld a, $56
    ld c, a                       ; Load pointer for LDH [$ff00 + C]
    ld a, $e0
    ld b, a                       ; Pre-load CP value for upper RAM boundary
                                  ; Higher performance due to register-based CP

    ; Record until RAM is full
.recordLoop
    ldh a, [c]
    ld [hli], a
    ld a, h
    cp b
    jr nz, .recordLoop

    ; Stop double speed mode
    ld a, 1
    ld [rKEY1], a
    stop

    ; Post-process recorded inputs
    call PostProcessRecording

    ; Re-enable interrupts
    call InitInterrupts

    jp MenuLoop

PostProcessRecording::
    ld hl, wRecordingBase

.postProcessingLoop
    ld a, [hl]
    xor $ff
    rra
    and $01
    ld [hli], a

    ld a, h
    cp b
    jr nz, .postProcessingLoop

    ret