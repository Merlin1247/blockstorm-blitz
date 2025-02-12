;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
.include "frameevents\title-f.s"
.include "frameevents\gamelost-f.s"
.include "frameevents\gamewon-f.s"
.include "frameevents\levelselect-f.s"
.include "frameevents\pause-f.s"
.include "frameevents\game-f.s"

WAITVBLANK:
  INC vBlankReady 
 :LDA vBlankReady
  BNE :-

STARTFRAME:
  JSR ReadControllerInputs
  INC globalTimer
  JMP (frameVector)