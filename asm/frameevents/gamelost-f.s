;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
GAMELOST_F:
  LDA globalTimer
  BNE :++
  LDA level
  BEQ :+
  DEC level
 :JSR LoadBackground
  LDX #1
  JSR UpdateVectors
 :JMP WAITVBLANK