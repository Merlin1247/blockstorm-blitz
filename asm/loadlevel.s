  ;Old block display - unused
  ;clc
  ;lda #50
  ;ldx #0
  ;ldy #$21
;: sta $E0, X
  ;sta $0700, y
  ;adc #254
  ;clc
  ;inx 
  ;iny
  ;cpx #$0E
  ;bne :-
  ;ldx #$20
  ;ldy #$82
  ;jsr LoadBlockRow 

  ;lda #$22
	;sta $F0
  ;lda #$4E
	;sta $F1
  ;ldy #40
  ;sty $0797
  ;jsr LoadBlock

  ;rts 

LoadBackground: ;Display static background elements
  
  sei ;Disable interrupts

  ldx #0
  stx ppuCtrl
  stx ppuMask ;Disable NMI + Rendering
  ;Clear PPU memory + page 7
  lda #$20
  sta ppuAddr
  stx ppuAddr
  txa
@LOOPPPU:
  sta ppuData
  sta ppuData
  sta ppuData
  sta ppuData
  sta healthPage, X
  inx
  bne @LOOPPPU

  jsr DrawHUD
  ; Start displaying sidebars
  clc
  ldy #$0
  lda #$DE
  ldx #$1F
: sty $F1 ;loop 4 times using y + $F1
  adc #$20
  tay
  txa
  adc #0
  tax
  tya
  stx $2006
  sty $2006
  ldy #$70;Draw line tiles
  sty $2007
  iny
  sty $2007
  iny
  sty $2007
  iny
  sty $2007
  ldy $F1
  iny
  cpy #$20
  bne :-
  
  ;Display blocks
  ldx level
  lda #opcodeLDAnnnnX
  sta LoadLevelData
  lda #opcodeRTS
  sta LoadLevelData+3

  lda LEVELDATAINDEXHI, X
  sta LoadLevelData+2
  lda LEVELDATAINDEXLO, X
  sta LoadLevelData+1
  
  lda #opcodeSTAnnnnY
  sta $D5
  lda #>healthPage
  sta $D7
  lda #opcodeJMPnnnn
  sta $D8
  lda #<RETURNFROMJMP
  sta $D9
  lda #>RETURNFROMJMP
  sta $DA
  
  lda ppuStatus ;Reset $2006 latch
  ldx #0

  jsr LoadLevelData
  sta ballXSpeed
  inx
  jsr LoadLevelData
  sta ballYSpeed
  inx
  jsr LoadLevelData
  sta ballXSubSpeed
  inx
  jsr LoadLevelData
  sta ballYSubSpeed
  inx
  jsr LoadLevelData
  sta ballXPos
  inx
  jsr LoadLevelData
  sta ballYPos
  inx

  jsr LoadLevelData
@LOOP:
  bmi @LINE
@ONEBLOCK:
  sta $E0
  inx
  jsr LoadLevelData
  tay
  lda $E0
  sta healthPage, Y
  clc
  tya
  and #%11000000
  rol A
  rol A
  rol A
  ora #%00100000
  sta $F0
  tya 
  and #%00110000
  rol A
  rol A ;test
  sta $F1
  tya
  and #%00001111
  rol A
  ora $F1
  sta $F1
  ldy $E0
  stx $E0
  jsr LoadBlock
  ldx $E0
  jmp @END
@LINE:
  tay
 @LOADNAMETABLEPOS:
  and #%00000011
  ora #%00100000
  sta ppuAddr
  sta $F0
  tya
  and #%01100000
  lsr A
  sta $D6
  asl A
  asl A
  ora #%00000010
  sta ppuAddr
  sta $F1
  tya
  ror A
  ror A
  ror A
  and #%11000000
  ora $D6
  ora #%00000001
  sta $D6
  tya
  ldy #0
 @BRANCH:
  and #%00001100
  beq @LINE8BPT
  cmp #%00000100
  beq @LINE1BPT
  cmp #%00001000
  beq @LINE2BPT
  cmp #%00001100
  beq @LINE4BPT
 @LINE8BPT:
  inx
  jsr $00D0
  sta $E0, Y
  iny
  cpy #$0E
  bne @LINE8BPT
  jmp @LOAD
 @LINE4BPT:
  
  jmp @LOAD
 @LINE2BPT:
  
  jmp @LOAD
 @LINE1BPT:
  inx
  jsr LoadLevelData
  sta $F3
  inx
  jsr LoadLevelData
  sta $F4
  inx
  jsr LoadLevelData
  sta $F5
  bmi @SINGLE
  
  @DOUBLE:
  lsr $F5
  bcs @SECOND
   @FIRST:
  lda $F3
  jmp @STORE
   @SECOND:
  lda $F4
   @STORE:
  sta $E0, Y
  iny
  cpy #$07
  bne :+
  inx
  jsr LoadLevelData
  sta $F5
: cpy #$0D
  bne @DOUBLE
  jmp @LOAD

  @SINGLE:
  lda #0
  lsr $F5
  bcs @STORE2
  lda $F3
   @STORE2:
  sta $E0, Y
  iny
  cpy #$07
  bne :+
  inx
  jsr LoadLevelData
  sta $F5
: cpy #$0D
  bne @SINGLE
  
  jmp @LOAD
 @LOAD:
  stx $D4
  jsr LoadBlockRow
  ldx $D4
@END:
  inx
  jsr LoadLevelData
  beq @FINISH
  jmp @LOOP
 @FINISH:
 ;Finish loading
 :bit ppuStatus
  bpl :-
  ldy #0
  sty $E0 ;Clear buffered block attribute change
  sty $E1
  sty ppuScroll
  sty ppuScroll
  lda ppuStatus
  lda #%10010100 ;ppuData set to $20, needed for vblank
  sta ppuCtrl ;When VBLANK occurs call NMI
  lda #%00011110
  sta ppuMask ;show sprites and background
  ;Setting sprite range
  lda #>oamBuffer
  sta oamDMA
  ldx #3
  ldy #$F6
 :sty time, X
  dex
  bpl :-
  cli ;Enable interrupts
  rts

LoadBlockRow:
  ;lda $2002 ;read PPU status to reset high/low latch
	;stx $2006 ;Load the position value into PPU
  ;stx $F0
	;sty $2006
  ;sty $F1
  ldy #0
 BLOCKROWLOOP:
  ldx $E0, Y ;First 2 values 14 times
  txa
  ;sta $0700 + posy, Y
  jmp $00D5
 RETURNFROMJMP:
  sty $DB
  tay
  bne @NOTZERO
  lax #$1D
  jmp :+
 @NOTZERO:
  jsr HexToDec255
  cpy #01
  beq @CASE100

  tay
  txa 
  adc #$10
  tax 
  tya
  adc #$30
  cpx #$13
  bmi :+
  adc #$1F
: stx $2007
  sta $2007
  jmp @CONTINUE

@CASE100:
  lda #$1F ;Load the correct tile x2
  ldx #$1E
  stx $2007
  sta $2007

@CONTINUE:
  ldy $DB
  stx $20, Y
  sta $10, Y
  iny
  cpy #$0E
  bne BLOCKROWLOOP;loop 14 times
  
  ldy #$70 ;Optimization: could store the ppuaddr in a temp register and add #$10
  sty $2007
  iny
  sty $2007
  iny
  sty $2007
  iny
  sty $2007

  ldy #0
  clc
: lda $20, y ;2nd 2 values 14 times
  ;cmp #100
  ;beq 100case
  adc #$10
  sta $2007
  lda $10, y
  adc #$10
  sta $2007
  iny
  cpy #$0E
  bne :-

  ldy #0 ;Set correct palettes
: sty $DB
  clc
  lda $E0, Y
  sta $F9
  jsr SetTilePalette
  inc $F1
  inc $F1
  bne :+
  inc $F0
: ldy $DB
  iny
  cpy #$0E
  bne :--

  rts