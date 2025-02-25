;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
FRAMEVECTORSLO:
  .byte <TITLE_F, <GAME_F, <PAUSE_F, <GAMELOST_F, <GAMEWON_F, <LEVELSELECT_F

FRAMEVECTORSHI:
  .byte >TITLE_F, >GAME_F, >PAUSE_F, >GAMELOST_F, >GAMEWON_F, >LEVELSELECT_F

VBLANKVECTORSLO:
  .byte <TITLE_V, <GAME_V, <PAUSE_V, <GAMELOST_V, <GAMEWON_V, <LEVELSELECT_V

VBLANKVECTORSHI:
  .byte >TITLE_V, >GAME_V, >PAUSE_V, >GAMELOST_V, >GAMEWON_V, >LEVELSELECT_V

PALETTEDATA:
  .byte @END-PALETTEDATA-1 ;length	
  .byte $12,$23,$34,$0F, $30,$30,$0F,$0F, $27,$11,$0F,$0F, $1C,$15,$30,$0F ;sprite palettes
  .byte $27,$11,$30,$0F, $29,$1A,$30,$0F, $17,$02,$30,$0F, $05,$13,$30,$0F ;background palettes
;block colours: 1-4 - purple, 5-9 - indigo, 10-19 - blue, 20-29 - green, 30-49 - yellow green, 50-69 - yellow, 70-89 - orange, 90-100 - red 
  .byte $00, $3F ;ppuAddr
  @END:

;SPRITEDATA: ;Y, sprite num, attributes, x
;  .byte $FF, $07, $00, $FF
;  .byte $DD, $03, $00, $00
;  .byte $DD, $04, $00, $00
;  .byte $DD, $04, $00, $00
;  .byte $DD, $05, $00, $00

ATTRIBUTEMASK:
.byte %00000011,%00110000,%00001100,%11000000

FIRSTLINE:
  .byte @END-FIRSTLINE-1 ;length
  .byte $03,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$01 ;Finish line
  .byte 4,0,$F6,6,0,$F5,$ED,$EE,$EA ;PTS:______0__\__
  .byte 3,0,$F5,$E6,$F0,$E6 ;LVL:___
  .byte 5,0,$F5,$DF,$E7,$E3,$EE ;TIME:_____
  .byte $22, $20 ;ppuAddr
 @END:

GAMEOVER:
  .byte @END-GAMEOVER-1 ;length
  .byte $EC,$DF,$F0,$E9,$6F,$DF,$E7,$DB,$E1
  .byte $EB, $21 ;ppuAddr
 @END:

YOUWIN:
  .byte @END-YOUWIN-1 ;length
  .byte $E8,$E3,$F1,$6F,$EF,$E9,$F3
  .byte $EC, $21 ;ppuAddr
 @END:

PRESSSTART:
  .byte @END-PRESSSTART-1 ;length
  .byte $EE,$EC,$DB,$EE,$ED,$6F,$ED,$ED,$DF,$EC,$EA ;PRESS START
  .byte $8A, $22 ;ppuAddr
 @END:

TITLELOGO:
  .byte @END-TITLELOGO-1 ;length
  .byte $6E,$6A,$5B,$4E,$3D,$3C,$1D,$2D,$1D
  .byte 23,0,$6D,$5F,$5A,$4E,$1B,$6F,$1B,$2C,$1C
  .byte 23,0,$6C,$6F,$5A,$4E,$3A,$6F,$1B,$2B,$1B 
  .byte 23,0,$6B,$4D,$4F,$4D,$5E,$6F,$3A,$2A,$1A
  .byte 17,0,$3D,$5D,$3D,$4A,$3D,$2D,$1D,$5B,$4E,$2D,$4D,$4A,$3D,$3C,$1D,$2D,$1D,$3C,$1D,$2D,$1D
  .byte 11,0,$1B,$1B,$1B,$3F,$1C,$1B,$1B,$5A,$4E,$4C,$4B,$3F,$1C,$6F,$1B,$1B,$1B,$6F,$1B,$2C,$1C
  .byte 11,0,$1B,$1B,$1B,$3E,$1B,$1B,$1B,$5A,$4E,$6F,$1B,$3E,$1B,$6F,$1B,$1B,$1B,$6F,$1B,$2B,$1B
  .byte 11,0,$3B,$5C,$1A,$3B,$1A,$3B,$1A,$4F,$4D,$3C,$1A,$3A,$3A,$3C,$1A,$3B,$1A,$6F,$3A,$2A,$1A
  .byte $C5, $20;ppuAddr
 @END:

LISCENSE:
  .byte @END-LISCENSE-1 ;length
  .byte $F4,$EE,$E3,$E6,$DC,$D8,$E7,$EC,$E9,$EE,$ED,$E5,$DD,$E9,$E6,$DC,$D7,20,0 ;blockstorm-blitz
  .byte $FD,$FA,$F8,$F7,$E8,$E3,$E6,$EC,$DF,$E7,$D7,$E7,$E9,$DD,$DA,$DC,$EF,$E2,$EE,$E3,$E1 ;github.com/Merlin1247
  .byte 43,0,$DA,$F1,$6F,$E8,$E9,$DE,$E8,$DB,$EC,$DC,$6F,$D6,$FB,$F8,$F6,$F8,$D9 ;(c)2025 BRANDON W.
  .byte $07, $23 ;ppuAddr
 @END: