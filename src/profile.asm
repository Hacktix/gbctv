SECTION "Profile System", ROM0
SwitchProfile::
    ; Add B to profile number
    ldh a, [hSelectedProfile]
    add b
    cp $ff
    jr nz, .noUnderflow
    ld a, MAX_PROFILE_NO
    jr .noOverflow
.noUnderflow
    cp MAX_PROFILE_NO+1
    jr nz, .noOverflow
    xor a
.noOverflow
    ldh [hSelectedProfile], a

    ; Switch RAM Bank
    ld hl, rRAMB
    ld [hl], a

    ; Print new number to screen
    call NibbleToASCII
    ld hl, ADDR_SYMBOL_PNUM
    ld [hl], a

    ; Update Cooldown
    ld a, PSWITCH_COOLDOWN
    ldh [hProfileCooldown], a

    ret