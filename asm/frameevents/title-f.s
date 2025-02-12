;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
TITLE_F:
  JSR LoadBackground

  LDX #1
  JSR UpdateVectors
  JMP WAITVBLANK