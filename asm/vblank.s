  ;Update game status
  PHA
  BIT gameStatus
  BVS :+
  JMP LOADOAM
 :LDA gameStatus
  AND #%10111111
  STA gameStatus
  BPL GAME
  AND #%00100000
  BNE WIN

LOSE:;Game over case
  LDX #<GAMEOVER
  LDA #>GAMEOVER
  BNE :+

WIN: ;Win case
  LDX #<YOUWIN
  LDA #>YOUWIN
 :JSR DrawText
  PLA
  RTI

GAME:

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

  LDA ppuCtrlTracker
  AND #%10111011
  STA ppuCtrl
  LDY #$20 ;Update points display
  sty ppuAddr
  LDA #$37
  STA ppuAddr
  LDX #$7A
 :LDA points-$7A, X
  STA ppuData
  INX
  BPL :-

  sty ppuAddr ;Update score display
  LDA #$27
  STA ppuAddr
  LDX #$7C
 :LDA time-$7C, X
  STA ppuData
  INX
  BPL :-

  LDA ppuCtrlTracker
  STA ppuCtrl

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
  BIT gameStatus
  BVS RETSINGLESTORE

  STY ppuScroll ;Y is always 0
  STY ppuScroll

 LOADOAM:
  LDA #>oamBuffer
  STA oamDMA ;Set sprite range  
  PLA
  RTI
 RETSINGLESTORE:
  RTS ;use from following sub

  ;nametableaddrhi (topleft tile)
  ;nametableaddrlo (topleft tile)
  ;tile index left (topleft tile)
  ;tile index right (topleft tile)
  ;nametableaddrlo (palette)
  ;pallette byte

  ;LDA $0300+25c, Y 