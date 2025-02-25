;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
TITLE_F:

  LDA #%00010000 ;Test if start is pressed
  BIT controller1Input
  BEQ :+
  JSR LoadBackground
  LDX #1
  JSR UpdateVectors

 :JMP WAITVBLANK