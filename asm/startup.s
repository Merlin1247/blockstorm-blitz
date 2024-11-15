  sei ;Disable IRQs
  cld ;Clear decimal mode

  ldx #%1000000 
  stx $4017 ;Disable sound IRQ
  lax #$00
  sta $4010 ;Disable DMC IRQs

  ;Clear PPU registers
  sta ppuCtrl
  sta ppuMask

  ;Initialize the stack pointer
  dex
  txs

: ;Wait for VBLANK
  bit ppuStatus
  bpl :-

  ;Clear CPU memory
  tay
@LOOPCPU:
  sta $0000, Y
  sta $0100, Y 
  txa
  sta $0200, Y
  lda #0
  sta $0300, Y
  sta $0400, Y
  sta $0500, Y
  sta $0600, Y
  sta $0700, Y
  iny
  bne @LOOPCPU

  stx gameStatus ;anything non-zero should work

  ldy #5
  lda #$F6
 :sta points, Y
  dey
  bpl :-

: ;Wait for VBLANK
  bit ppuStatus
  bpl :-

: ;Wait for VBLANK
  bit ppuStatus
  bpl :-

  nop
  lda #$3F ;$3F00
  sta ppuAddr
  lda #$00
  sta ppuAddr
  ldx #0
@LOADPALETTES:
    lda PALETTEDATA, x
    sta ppuData
    inx
    cpx #$20
    bne @LOADPALETTES
  
  ldx #$00
@LOADSPRITES:
    lda SPRITEDATA, x
    sta oamBuffer, x
    inx
    cpx #$14
    bne @LOADSPRITES

  ;Reset scroll
	lda #$00
	sta ppuScroll
	sta ppuScroll

  ;Set paddle position
  lda #$70
  sta paddleX

  jsr LoadBackground

  lda #0
  sta gameStatus