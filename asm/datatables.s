PALETTEDATA:
	.byte $0F, $30, $11, $27,   $0F, $30, $02, $17,   $0F, $30, $13, $06,  	$0F, $30, $1A, $29 	;background palettes
;block colours: 1-4 - purple, 5-9 - indigo, 10-19 - blue, 20-29 - green, 30-49 - yellow green, 50-69 - yellow, 70-89 - orange, 90-100 - red 
	.byte $0F, $30, $15, $1C, 	$0F, $0F, $11, $27, 	$00, $0F, $30, $30, 	$00, $3C, $2C, $30 	;sprite palettes

SPRITEDATA: ;Y, sprite num, attributes, x
  .byte $FF, $07, $00, $FF
  .byte $DD, $03, $00, $00
  .byte $DD, $04, $00, $00
  .byte $DD, $04, $00, $00
  .byte $DD, $05, $00, $00

FIRSTLINE:
  .byte $70, $71, $EE, $E3, $E7, $DF, $F5, $D1, $D1, $D1, $D1, $D0, $E6, $F0, $E6, $F5, $D1, $D2, $D0, $EA, $EE, $ED, $F5, $D1, $D1, $D1, $D1, $D1, $D1, $D1

GAMEOVER:
  .byte $E1, $DB, $E7, $DF, $D0, $E9, $F0, $DF, $EC

YOUWIN:
  .byte $F3, $E9, $EF, $D0, $F1, $E3, $E8