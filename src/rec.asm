SECTION "Recording", ROM0
StartRecording::
    ; Disable Interrupts
    di

    ; Set recording icon
    ld hl, ADDR_SYMBOL_A
    ld a, REC_SYMBOL_TILENO
    ld [hl], a

    ; Initialize IR reading
    ld a, RPF_ENREAD
    ld [rRP], a

    ; Wait for first signal to arrive
.recordWaitLoop
    ld a, [rRP]
    bit 1, a
    jp nz, .recordWaitLoop

    ; Initialize system for high-speed IR reading
    ld a, KEY1F_PREPARE
    ld [rKEY1], a
    stop                          ; Double-speed mode
    ld hl, wRecordingBase         ; Pre-load RAM pointer
    ld a, LOW(rRP)
    ld c, a                       ; Load pointer for LDH [$ff00 + C]
    ld a, HIGH(_RAM)
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
    ld a, KEY1F_PREPARE
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
    and RPF_DATAIN
    rra
    ld [hli], a

    ld a, h
    cp b
    jr nz, .postProcessingLoop

    ret