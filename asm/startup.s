  SEI ;Disable IRQs

  STY $4010 ;Disable DMC IRQs
  LDA #%10000000
  STA $4017 ;Disable sound IRQ

  ;Clear PPU registers
  STX ppuCtrl
  STY ppuMask

  ;Initialize the stack pointer
  TXS

: ;Wait for VBLANK
  BIT ppuStatus
  BPL :-

  ;Clear CPU memory
  ;lda #3
  ;sta $B1
  ;stx $B0
 @LOOPCPU:
 ;.byte $93, $B0 sha
  STX $00, Y
  .byte $9E, $00, >blockHitBuffer ;shx $0700, Y
  ;sta blockHitBuffer, Y
  INY
  BNE @LOOPCPU
  ;dec $B1
  ;bpl :-

  LDX #5
  STX healthPageIndex+1

  INX ;6
  STX ballIndex+1
  STX ballIndex+3

  ;ldx #6
  LDA #$F6
 :STA points-1, X
  DEX
  BNE :-

  STA gameStatus ;anything with bit 6 set will work

: ;Wait for VBLANK
  BIT ppuStatus
  BPL :-

: ;Wait for VBLANK (???)
  BIT ppuStatus
  BPL :-

  STX ppuCtrl
  STX ppuCtrlTracker

  LDX #<PALETTEDATA
  LDA #>PALETTEDATA
  JSR DrawText
  
  ;ldx #$00
;@LOADSPRITES:
    ;lda SPRITEDATA, x
    ;sta oamBuffer, x
    ;inx
    ;cpx #$14
    ;bne @LOADSPRITES

  ;Set paddle position
  LDA #$70
  STA paddleX

  
  ;lda #1
  ;sta level

  JSR LoadBackground

  TSX
  STX gameStatus