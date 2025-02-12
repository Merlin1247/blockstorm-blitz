;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
GAMELOST_V:;Game over case
  LDX #<GAMEOVER
  LDA #>GAMEOVER
  BNE GAMEWONJSR