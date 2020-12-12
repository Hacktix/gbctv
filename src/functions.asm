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