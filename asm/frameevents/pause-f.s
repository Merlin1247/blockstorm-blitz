;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
PAUSE_F:
  LDX #6*4+4 ;sprite 0 + 6 pause sprites
  LDA #$FF
 :STA stackMem, X
  INX ;could use AXS (4x faster)
  BNE :-



  LDX #>stackMem
  STX oamHiByte
  LDY #%10110100

  LDA controller1Press
  AND #%00010000
  BEQ :+
  STX gameModeBuffer
  INC oamHiByte
  LDY #%10010100
 :STY ppuCtrlTracker
  JMP WAITVBLANK