SECTION "Functions", ROM0
;------------------------------------------------------------------------
; Copies BC bytes to a memory region starting at HL from a memory
; region starting at DE.
;------------------------------------------------------------------------
Memcpy::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, Memcpy
    ret

;------------------------------------------------------------------------
; Copies a null-terminated string pointed to by DE to HL (excluding
; the terminating zero-byte)
;------------------------------------------------------------------------
Strcpy::
    ld a, [de]
    and a
    ret z
    ld [hli], a
    inc de
    jr Strcpy

;------------------------------------------------------------------------
; Converts the lower nibble of A to an ASCII value and stores it in A.
;------------------------------------------------------------------------
NibbleToASCII:
    and $0f
    cp 10
    jr c, .digit
    add a, "A" - 10 - "0"
.digit
    add a, "0"
    ret