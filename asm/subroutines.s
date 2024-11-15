ReadControllerInputs:
  ldy #1 
  sty controller1, X ;Initialize output memory
  sty $4016
  dey
  sty $4016 ;Send a pulse to the 4021
  READLOOP:
    lda $4016
    lsr A
    rol controller1, X
    bcc READLOOP
  rts
  
SetBallSpdXLeft:
  lda ballXSpeed
  bmi :++
  eor #%11111111
  tay
  lda ballXSubSpeed
  eor #%11111111
  tax
  inx
  bne :+
  iny
 :sty ballXSpeed
  stx ballXSubSpeed
 :rts

SetBallSpdXRight:
  lda ballXSpeed
  bpl :++
  eor #%11111111
  tay
  lda ballXSubSpeed
  eor #%11111111
  tax
  inx
  bne :+
  iny
 :sty ballXSpeed
  stx ballXSubSpeed
 :rts

SetBallSpdYUp:
  lda ballYSpeed
  bmi :++
  eor #%11111111
  tay
  lda ballYSubSpeed
  eor #%11111111
  tax
  inx
  bne :+
  iny
 :sty ballYSpeed
  stx ballYSubSpeed
 :rts

SetBallSpdYDown:
  lda ballYSpeed
  bpl :++
  eor #%11111111
  tay
  lda ballYSubSpeed
  eor #%11111111
  tax
  inx
  bne :+
  iny
 :sty ballYSpeed
  stx ballYSubSpeed
 :rts

;minus to plus conversion ex:
;%00000001.000000001 -->
;%11111110.111111111
;%00000101.100000001 -->
;%11111010.011111111
;%00000010.100000000 -->
;%11111101.100000000

DrawText:
  sty ppuAddr
  sta ppuAddr
 :jsr $00D0
  sta ppuData
  dex
  bne :-
  rts

DrawHUD:
 ;First line (temp)
  lda #$20 
	sta ppuAddr
	sta ppuAddr
  ldx #0
 :ldy FIRSTLINE, X
  sty ppuData
  inx
  cpx #$1E
  bne :-

 ;Level count
  ldy level
  iny
  jsr HexToDec255
  lda #$20 
	sta ppuAddr
  lda #$30 
	sta ppuAddr
  txa
  adc #$D1
  sta ppuData
  lda $F5
  adc #$D1
  sta ppuData

 ;Finish line
  ldx #38
  lda #$20
  sta ppuAddr
  lda #$42
  sta ppuAddr
  ldy #$01
  sty ppuData
  iny
: inx
  sty ppuData
  cpx #64
  bne :-
  iny
  sty ppuData
  rts

HexToDec255:
  tya                         ; A = 0-255
  ldy    #0
  cmp    #100
  bcc    @DONE100
  iny
  sbc    #200
  bcc    @USE100
  iny                          ; If a mapper conflicts with SBC #-101 (becomes BIT $9BE9), then you can try:
  .byte $2C                    ; - 'BNE .done100' instead of .byte $2C, as Y=2 or Y=$32 at this point...
@USE100:
  adc    #100                 ; - substitute with SBC #-101 with ADC #100 (which would become BIT $6469) 
@DONE100:                        
  ldx    #0
  cmp    #50                   
  bcc    @TRY20
  sbc    #50
  ldx    #5
  bne    @TRY20               ; always branch
@DIV20:
  inx
  inx
  sbc    #20
@TRY20:
  cmp    #20
  bcs    @DIV20
@TRY10:
  cmp    #10
  bcc    @FINISHED
  sbc    #10
  inx
@FINISHED:
  sty $F3 ; Y = decimal hundreds
  stx $F4 ; X = decimal tens
  sta $F5 ; A = decimal ones
  clc
  rts

HitBlock:
  tax
  and #%11000000
  rol A
  rol A
  rol A
  tay
  dec healthPage, X
  txa
  and #%00001111
  asl A
  sta $F0
  txa
  rol A
  rol A
  and #%11000000
  ora $F0
  sta $F1
  clc
  tya
  adc #$20
  sta $F0
  lda #1
  ldy healthPage, X
  bne :+
  lda #5
 :ldx #5
  jsr AddPoints

  jsr LoadBlock
  rts

LoadBlock: ; y = health, 
  ;lda ppuStatus ;read PPU status to reset high/low latch

  tya ;Find current case
  sta $F9
  ;cmp #0
  beq :++
  cmp #100
  beq :+++
  
  jsr HexToDec255 ;Generic 1-99
  lda #$10
  adc $F4
  sta $F6
  ldx #0
  cmp #$13
  bmi :+
  clc
  ldx #$20

: txa
  adc #$30
  adc $F5
  sta $F7
  jmp :+++
  
  : ; 0 case
  lda #$1A
  sta $F6
  sta $F7
  jmp :++

  : ;100 case
  ldx #$1E
  stx $F6
  inx
  stx $F7

: jsr SetTilePalette

  lda $00
  beq :+

  lda $F0 ;Load the position value into PPU
	sta ppuAddr
	lda $F1
	sta ppuAddr

  lda $F6 ;Load the correct tile x2
  sta ppuData
  lda $F7
  sta ppuData

  lda $F1 ;Add 32 to the position value
  clc
  adc #$20
  tax
  lda $F0
  adc #0 
	sta ppuAddr
	stx ppuAddr

  lda $F6 ;Load the correct tile x2
  adc #$10
  sta ppuData
  lda $F7
  adc #$10
  sta ppuData
  
  rts

: ldx #0
  lda $E0
  beq :+
  inx
 :lda $F0
  sta $E0, X
  lda $F1
  sta $E2, X
  lda $F6
  sta $E4, X
  lda $F7
  sta $E6, X
  rts

SetTilePalette:

  lda $F9
  cmp #05
  bmi :+++
  cmp #90
  bpl :+++
  cmp #10
  bmi :++
  cmp #70
  bpl :++
  cmp #20
  bmi :+
  cmp #50
  bpl :+ ;jump table?
  lda #%11111111
  jmp @STOREBASEPALETTE
: lda #%00000000
  jmp @STOREBASEPALETTE
: lda #%01010101
  jmp @STOREBASEPALETTE
: lda #%10101010
 @STOREBASEPALETTE:
  sta $FB ;Store new palette

  lda $F1
  and #%11100000 ;make sure carry is reset if needed
  clc
  rol A
  rol A
  rol A
  rol A
  sta $FA ; high bits of F1
  lda $F0
  and #%00000011
  rol A
  rol A
  rol A
  ora $FA
  and #%11111100
  rol A
  sta $FA
  lda $F1
  ;and #%00011111
  ;and #%11111100
  ;ror A
  arr #%00011100
  ror A
  adc #$C0
  adc $FA
  tay ;attribute low byte now in Y
  
  lda $F1
  and #%01000000
  rol A
  rol A
  rol A
  rol A
  sta $FA
  lda $F1
  and #%00000010
  ror A
  ora $FA
  sta $FA ;Get the correct position for the mask of the attribute byte

  lda #%00000011 ;Get default mask
  ldx #0
  jmp :++
: rol A
  rol A
  inx
: cpx $FA
  bne :-- ;Correct mask for the attribute byte in accumulator
  eor #%11111111
  tax
  eor #%11111111

  and $FB
  sta $FB ;Mask new palette with correct position

  lda $00
  beq :+
  
  lda #$23
	sta ppuAddr
	sty ppuAddr
  lda ppuData ; Totally 100% necessary
  lda ppuData ; Current palette data in accumulator
  sta $0F

  txa
  and $0F ; Other 3 palette bits in accumulator
  ora $FB ; Combine with new palette data

  ldx #$23
	stx ppuAddr
	sty ppuAddr
  sta ppuData ; Store final palette data
  rts

: lda $E0
  bne :+
  sty $E8
  stx $EA
  lda $FB
  sta $EC
  rts
: sty $E9
  stx $EB
  lda $FB
  sta $ED
  rts

AddPoints: ;x= adding byte a = value (0-10)
  clc
 @ADDLOOP:
  adc points, X
  bcc :+
  adc #$F6-1 ;carry is set
  sta points, X
  lda #1
  dex
  bpl @ADDLOOP
  ;lda #5
  ;stx points, A
  ;loop
  rts
 :sta points, X
  rts

IncTime: ;increment time
  ldx #3
  lda #$F6
 @ADDLOOP:
  inc time, X
  bne :+
  sta time, X
  dex
  bpl @ADDLOOP
  ;lda #$FF
  ;sta points
 :rts