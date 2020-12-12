SECTION "Functions", ROM0
Memcpy::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, Memcpy
    ret

Strcpy::
    ld a, [de]
    and a
    ret z
    ld [hli], a
    inc de
    jr Strcpy

NibbleToASCII:
    and $0f
    cp 10
    jr c, .digit
    add a, "A" - 10 - "0"
.digit
    add a, "0"
    ret