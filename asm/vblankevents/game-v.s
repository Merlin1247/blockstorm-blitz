;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
GAME_V:

  CLC ;Set paddle components' X position (can move out of NMI)
  LDA $03
  STA oamBuffer+$87
  ADC #$08
  STA oamBuffer+$8B
  ADC #$08
  STA oamBuffer+$8F
  ADC #$08
  STA oamBuffer+$83
  ADC #$08
  STA $F1

  LDY #bhbLength
 BlockLoop:
  LDA bhbAddrHi, Y ;Update block tile
  BEQ :+
  ;LDA #%10010100
  ;STA ppuCtrl
 SingleStore:
  STA ppuAddr
  LDX bhbAddrLo, Y ;bit 5 is always clear
  .byte $9E, $00, $1F;SHX mirror of bhb (H+1=$20 H = $1F) Could be put out of vblank?
  STX ppuAddr
  STA ppuAddr
  LDA bhbTileTL, Y
  STA ppuData
  ADC #$10
  STA ppuData
  INX
  STX ppuAddr
  LDA bhbTileTR, Y
  STA ppuData
  ADC #$10
  STA ppuData
  ;Store new pallette data
  LDX bhbPaletteAddrLo, Y
  LDA #$23
  STA ppuAddr ;set w
  STX ppuAddr
  STA ppuAddr
  LDA ppuData ; Totally 100% necessary
  LDA bhbPaletteMask, Y ;unaffected palette mask
  AND ppuData ; Other 3 palette bits in accumulator
  ORA bhbNewPalette, Y ; Combine with new palette data
  STX ppuAddr
  STA ppuData ; Store final palette data
  ;Store 0 to mark slot as empty
 :DEY
  BNE BlockLoop ;107/108
  
  LDA vBlankReady
  BEQ RETSINGLESTORE

  LDA ppuCtrlTracker
  AND #%10111011
  STA ppuCtrl
  LDY #$20 ;Update points display
  STY ppuAddr
  LDA #$37
  STA ppuAddr
  STY ppuAddr
  LDX #$7A
 :LDY points-$7A, X
  STY ppuData
  INX
  BPL :-

  LDA #$27 ;Update score display
  STA ppuAddr
  LDX #$7C
 :LDY time-$7C, X
  STY ppuData
  INX
  BPL :-

  SAX ppuScroll ;X=$80 A=$27
  SAX ppuScroll

  ;JMP PREPVBLKEND