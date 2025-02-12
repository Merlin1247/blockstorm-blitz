;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
GAMEWON_F:
  LDA globalTimer
  BNE :++
  LDX level
  INX
  CPX #levelCount
  BNE :+
  TSX ;0
 :STX level
  JSR LoadBackground
  LDX #1
  JSR UpdateVectors
 :JMP WAITVBLANK