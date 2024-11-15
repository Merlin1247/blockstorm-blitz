  ;Update game status
  bit gameStatus
  bvs :+
  jmp LOADOAM
 :lda #%10010000
  sta ppuCtrl
  lda gameStatus
  and #%10111111
  sta gameStatus
  bpl GAME
  and #%00100000
  bne WIN

LOSE:;Game over case
  lda #$21
  sta ppuAddr
  lda #$EB
  sta ppuAddr
  ldx #0
  stx ppuScroll
  stx ppuScroll
: lda GAMEOVER, X
  sta ppuData
  inx
  cpx #$09
  bne :-
  rti

WIN: ;Win case
  lda #$21
  sta ppuAddr
  lda #$EC
  sta ppuAddr
  ldx #0
  stx ppuScroll
  stx ppuScroll
 @WINTEXTLOOP:
  lda YOUWIN, X
  sta ppuData
  inx
  cpx #$07
  bne @WINTEXTLOOP
  rti

GAME:
  clc ;Set paddle components' X position
  lda $03
  sta $0207
  adc #$08
  sta $020B
  adc #$08
  sta $020F
  adc #$08
  sta $0213
  adc #$08
  sta $F1

  ldy #$20
  sty ppuAddr
  lda #$37
  sta ppuAddr
  ldx #$7A
 :lda points-$7A, X
  sta ppuData
  inx
  bpl :-

  sty ppuAddr
  lda #$27
  sta ppuAddr
  ldx #$7C
 :lda time-$7C, X
  sta ppuData
  inx
  bpl :-


  ldx #%10010100
  stx ppuCtrl

  ldy #1
 :ldx $E0, Y ;Update block tile
  beq :+
  ;lda #%10010100
  ;sta ppuCtrl
  stx ppuAddr
  lda $E2, Y
  sta ppuAddr
  lda $E4, Y
  sta ppuData
  adc #$10
  sta ppuData
  stx ppuAddr
  ldx $E2, Y
  inx
  stx ppuAddr
  lda $E6, Y
  sta ppuData
  adc #$10
  sta ppuData 
  ;Store new pallette data
  ldx #$23
	stx ppuAddr
  lda $E8, Y
	sta ppuAddr
  lda ppuData ; Totally 100% necessary
  lda ppuData ; Current palette data in accumulator
  sta $0F
  lda $EA, Y
  and $0F ; Other 3 palette bits in accumulator
  ora $EC, Y ; Combine with new palette data
	stx ppuAddr
  ldx $E8, Y
	stx ppuAddr
  sta ppuData ; Store final palette data
 :dey
  bpl :--

  lda #0
  sta ppuScroll
  sta ppuScroll
  sta $E0
  sta $E1
  
  lda ballXPos
  ;adc #$FE
  sta $0203 ;Set ball x
  lda ballYPos
  sta $0200 ;Set ball y

 LOADOAM:
  pha
  lda #>oamBuffer
  sta oamDMA ;Set sprite range  
  pla
  rti