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
  .byte $12,$23,$34,$00, $30,$30,$0F,$00, $27,$11,$0F,$0F, $1C,$15,$30,$0F ;sprite palettes
  .byte $27,$11,$30,$0F, $29,$1A,$30,$0F, $17,$02,$30,$0F, $06,$13,$30,$0F ;background palettes
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
  .byte 0,0,0,0,$F6,0,0,0,0,0,0,$F5,$ED,$EE,$EA ;PTS:______0__\__
  .byte 0,0,0,$F5,$E6,$F0,$E6 ;LVL:___
  .byte 0,0,0,0,0,$F5,$DF,$E7,$E3,$EE ;TIME:_____
  .byte $22, $20 ;ppuAddr
 @END:

GAMEOVER:
  .byte @END-GAMEOVER-1 ;length
  .byte $EC,$DF,$F0,$E9,0,$DF,$E7,$DB,$E1
  .byte $EB, $21 ;ppuAddr
 @END:

YOUWIN:
  .byte @END-YOUWIN-1 ;length
  .byte $E8,$E3,$F1,0,$EF,$E9,$F3
  .byte $EC, $21 ;ppuAddr
 @END: