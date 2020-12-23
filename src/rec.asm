SECTION "Recording", ROM0

;------------------------------------------------------------------------
; Waits for a HIGH IR signal to start recording signal data and storing
; it on the currently selected SRAM bank.
;------------------------------------------------------------------------
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

    ; Disable IR Read & Write
    xor a
    ld [rRP], a

    ; Post-process recorded inputs
    call PostProcessRecording

    ; Re-enable interrupts and return to menu loop
    call InitInterrupts
    jp MenuLoop

;------------------------------------------------------------------------
; Should be called after each recording. Iterates over all "raw" IR-reg
; input byte values and converts them to values that can be written to
; the register to output the recorded signal.
;------------------------------------------------------------------------
PostProcessRecording::
    ; Load base pointer
    ld hl, wRecordingBase

.postProcessingLoop
    ; Process recorded byte
    ld a, [hl]
    xor $ff               ; Flip bits (Input 1 = Low Signal, Input 0 = High Signal)
    and RPF_DATAIN        ; Zero out all bits other than the actual data bit
    rra                   ; Shift input-bit right by one to output bit
    ld [hli], a           ; Overwrite original value in SRAM

    ; Check if end of SRAM is reached
    ld a, h
    cp b
    jr nz, .postProcessingLoop
    ret