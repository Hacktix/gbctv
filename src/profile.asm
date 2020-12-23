SECTION "Profile System", ROM0
;------------------------------------------------------------------------
; Takes value in B register (either +1 or -1) to add to the currently
; selected profile ID and switches the SRAM bank accordingly.
;------------------------------------------------------------------------
SwitchProfile::
    ; Add B to profile number
    ldh a, [hSelectedProfile]
    add b
    cp $ff                    ; Sets zero flag if underflow occurs
    jr nz, .noUnderflow       ; If underflowing, reset to MAX_PROFILE_NO
    ld a, MAX_PROFILE_NO
    jr .noOverflow
.noUnderflow
    cp MAX_PROFILE_NO+1       ; Sets zero flag if overflow occurs
    jr nz, .noOverflow        ; If overflowing, reset to zero
    xor a
.noOverflow

    ; Update HRAM variable and switch SRAM bank
    ldh [hSelectedProfile], a
    ld [rRAMB], a

    ; Print new number to screen
    call NibbleToASCII
    ld [ADDR_SYMBOL_PNUM], a

    ; Update Cooldown and return
    ld a, PSWITCH_COOLDOWN
    ldh [hProfileCooldown], a
    ret