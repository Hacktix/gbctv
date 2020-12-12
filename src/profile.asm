SECTION "Profile System", ROM0
SwitchProfile::
    ; Add B to profile number
    ldh a, [hSelectedProfile]
    add b
    cp $ff
    jr nz, .noUnderflow
    ld a, $0f
    jr .noOverflow
.noUnderflow
    cp $10
    jr nz, .noOverflow
    xor a
.noOverflow
    ldh [hSelectedProfile], a

    ; Print new number to screen
    call NibbleToASCII
    ld hl, $996e
    ld [hl], a

    ; Update Cooldown
    ld a, $0a
    ldh [hProfileCooldown], a

    ret