;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.

  PHA
  LDA vBlankReady
  BNE :+
  JMP LOADOAM
 :JMP (vBlankVector)

.include "vblankevents\title-v.s"
.include "vblankevents\gamelost-v.s"
.include "vblankevents\gamewon-v.s"
.include "vblankevents\levelselect-v.s"
.include "vblankevents\game-v.s"
 PAUSE_V:
 
  LDX ppuCtrlTracker
  STX ppuCtrl
  LDX gameModeBuffer
  BMI PREPVBLKEND
  JSR UpdateVectors
  STA gameModeBuffer ;Something w/bit 7 set
 PREPVBLKEND:
  LSR vBlankReady
 LOADOAM:
  LDA oamHiByte
  STA oamDMA ;Set sprite range  
  PLA
  RTI
 RETSINGLESTORE:
  RTS ;use from following sub

  ;LDA $0300+25c, Y 