SECTION "Font", ROM0
FontTiles:
INCBIN "inc/font.chr"
FontTilesEnd:

SECTION "Strings", ROM0
strTitle: db "Welcome to GBCTV", 0
strPressA: db "(A) Record Signal", 0
strPressB: db "(B) Replay Signal", 0