SECTION "Font", ROM0
FontTiles:
INCBIN "inc/font.chr"
FontTilesEnd:

SECTION "Strings", ROM0
strNonCGB_L1: db "  This program is  ", 0
strNonCGB_L2: db "Gameboy Color Only!", 0
strTitle: db "Welcome to GBCTV", 0
strPressA: db "(A) Record Signal", 0
strPressB: db "(B) Replay Signal", 0
strProfile: db "Profile: < 0 >", 0