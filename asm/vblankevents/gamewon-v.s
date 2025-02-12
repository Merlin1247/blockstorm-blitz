;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
GAMEWON_V: ;Win case
  LDX #<YOUWIN
  LDA #>YOUWIN
 GAMEWONJSR:
  JSR DrawText
  JMP PREPVBLKEND