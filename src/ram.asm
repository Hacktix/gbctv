SECTION "SRAM", SRAM
wRecordingBase: db          ; Base pointer to SRAM for recording/playback of IR signals

SECTION "HRAM", HRAM
hInitialRegA: db            ; Initial value of the A register on bootup
hSelectedProfile: db        ; Selected profile number (= SRAM bank number)
hProfileCooldown: db        ; Amount of frames left during which the profile selection cannot be changed