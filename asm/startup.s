;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.

  SEI ;Disable IRQs

  STY $4010 ;Disable DMC IRQs
  LDA #%10000000
  STA $4017 ;Disable sound IRQ

  TXS ;Initialize the stack pointer

  BIT ppuStatus ;Make sure vblank flag is clear

 ;Wait for VBLANK
 :BIT ppuStatus
  BPL :-

  ;Clear CPU memory
 @LOOPCPU:
 ;.byte $93, $B0 sha
  STX $00, Y
  .byte $9E, $00, >blockHitBuffer ;shx $0700, Y
  INY
  BNE @LOOPCPU

  JSR UpdateVectors

  STX stackMem+1 ;set sprite 0 blank, since its Y pos is part of stack

 ;Set up pause sprites
  LDX #5*4+3
 :TXA
  ASL A
  ADC #$80-$18-6
  STA stackMem+3+1, X ;X pos
  LDA #$78-8-8-1
  STA stackMem+0+1, X ;Y pos
  TXA
  LSR A
  ;LSR A
  ;ASL A
  ADC #$10-2
  STA stackMem+1+1, X ;Tile
  TXA
  STA stackMem+2+1, X ;bits 7-5 are 0, 1-0 are 1, 4-2 don't matter
  AXS #4
  BPL :-

  LDX #2
  STX oamHiByte

  LDX #5
  STX healthPageIndex+1

  INX ;6
  STX ballIndex+1
  STX ballIndex+3

  ;LDX #6
  LDA #$F6
 :STA points-1, X
  DEX
  BNE :-

  STA gameModeBuffer ;Something negative

  ;Set paddle position
  LDA #$70
  STA paddleX

  ;Wait for VBLANK
 :BIT ppuStatus
  BPL :-

  ;Wait for VBLANK (???)
 :BIT ppuStatus
  BPL :-
  ;PPU registers are now stable

  ;PpuCtrl & Tracker are 0

  LDX #<PALETTEDATA
  LDA #>PALETTEDATA
  JSR DrawText

  ;LDA #2
  ;STA level