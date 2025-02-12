;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
GAME_F:

  LDX #bhbLength
  STX bhbIndex

  ;Move paddle right
  LDA controller1Input
  LSR A
  BCC :+
  LDY #$D0
  CPY paddleX
  BEQ :+
  INC paddleX
: 
  ;Move paddle left
  LSR A
  BCC :+
  LDY #$10
  CPY paddleX
  BEQ :+
  DEC paddleX
: 
  LDA controller1Press
  AND #%00010000;Start
  BEQ :+
  LDA #2 ;2
  STA gameModeBuffer
  :


  LDX #maxBallCount*4+4;+4 to avoid using sprite 0
  LDA #maxBallCount*6
 BALLLOOP:
  STA ballIndex

  TXA
  AXS #4 ;Not affected by C

  LDY #5 ;Load current ball data
 :LDA (ballIndex), Y
  STA ballTemp+2, Y
  DEY
  BPL :-

  ;A already contains X speed
  ARR #%11111111 ;Sets V if bit 6 of result != bit 5, C always clear w/ $40
  ;Note: CMP does not work since it messes with carry

  BVC :+
  JMP DECBALLINDEX
  :

  STX oamBufferIndex

  CLC ;Increase ball x
  LDA ballXSubPosTemp
  ADC ballXSubSpeedTemp
  STA ballXSubPosTemp
  LDA oamBuffer+3, X
  ADC ballXSpeedTemp
  STA ballXPosTemp

  CLC ;Increase ball y (Put after border to clear C?)
  LDA ballYSubPosTemp
  ADC ballYSubSpeedTemp
  STA ballYSubPosTemp
  LDA oamBuffer+0, X
  ADC ballYSpeedTemp
  STA ballYPosTemp


  LDA #$10 ;Figure out if the ball hits a horizontal wall
  CMP ballXPosTemp
  BCC :+
  STA ballXPosTemp
  JSR SetBallSpdXRight
: LDA #$EB
  CMP ballXPosTemp
  BCS :+
  STA ballXPosTemp
  JSR SetBallSpdXLeft
:

;Block collision detection:
  LDA ballXPosTemp
  SEC
  SBC #08
  LSR A
  LSR A
  LSR A
  ;lsr A
  ;and %00001111
  STA $FC
  LDA ballYPosTemp
  SEC
  SBC #08
  AND #%11110000
  SRE $FC
  STA $FD
  TAX ;X contains the memory location of the health of the top-leftmost block

  LDA hitboxPage, X
  STA $FC

.macro wallpush vertical, hitboxedge, hitboxedgeside, hitboxfront, hitboxdir, blockHit, prevSameCollisions
  .local NOHIT
  .local EXIT
  .local parallelaxis
  .local pushaxis
  .local moveBuffer
  ASL $FC
  BCC NOHIT ;1
  .if vertical
    .define parallelaxis ballXPosTemp
    .define pushaxis ballYPosTemp
    .define moveBuffer $EF
  .else
    .define parallelaxis ballYPosTemp
    .define pushaxis ballXPosTemp
    .define moveBuffer $EE
  .endif
  LDA parallelaxis ;2
  ADC #7 ;Carry always set, so +1
  AND #%00001111
  .if hitboxedgeside
    CMP #16-hitboxedge-1
    BMI NOHIT 
  .else
    CMP #hitboxedge+1
    BPL NOHIT
  .endif ;3
  LAX pushaxis ;3b
  CLC ;could replace w/ .if hitbox edge #-1
  ADC #8
  AND #%00001111 ;carry always clear
  .if !hitboxdir
    CMP #hitboxfront+1
    BPL NOHIT
    CMP #hitboxfront-4
    BMI NOHIT
    ;adc #$FE-hitboxfront
    ;adc #6
    ;bcs NOHIT
  .else
    CMP #hitboxfront
    BMI NOHIT
    CMP #hitboxfront+5
    BPL NOHIT
    ;adc #$FA-hitboxfront
    ;adc #6
    ;bcs NOHIT
  .endif ;4
  TXA
  CLC
  SBC #7 ;-1, carry clear
  AND #%11110000 ;carry is set
  .if !hitboxdir
    ADC #hitboxfront+8
  .else
    ADC #hitboxfront+6
  .endif
  SEC
  SBC pushaxis
  SEC
  SBC moveBuffer
  STA moveBuffer ;6
  .if vertical
    .if !hitboxdir
      JSR SetBallSpdYDown
    .else
      JSR SetBallSpdYUp
    .endif
  .else
    .if !hitboxdir
      JSR SetBallSpdXRight
    .else
      JSR SetBallSpdXLeft
    .endif
  .endif ;7

  .if prevSameCollisions
    LSR cellBlockHits
    BCS EXIT
  .else
    SEC
    ROL cellBlockHits
  .endif

  .if blockHit = 1
    LDA #$00
  .elseif blockHit = 2
    LDA #$01
  .elseif blockHit = 3
    LDA #$10
  .elseif blockHit = 4
    LDA #$11 
  .endif

  JSR HitBlock

  BNE EXIT
  NOHIT:
    .if prevSameCollisions
      LSR cellBlockHits
    .else
      CLC
      ROL cellBlockHits
    .endif
  EXIT:
.endmacro

;00010100

  wallpush 0, 4, 0, 7, 0, 1, 0 ;AB
  wallpush 1, 5, 0, 6, 0, 1, 1 ;AC
  wallpush 0, 4, 0, 4, 1, 2, 0 ;BA
  wallpush 1, 5, 0, 3, 1, 3, 0 ;CA
  wallpush 0,10, 1, 4, 1, 4, 0 ;DC
  wallpush 1, 9, 1, 3, 1, 4, 1 ;DB
  wallpush 0,10, 1, 7, 0, 3, 1 ;CD
  wallpush 1, 9, 1, 6, 0, 2, 1 ;BD

@WINLOSE: ;Check if the game is won or lost
  ;lda #0
  ;sta $FC

  ;lda ballYPosTemp ;inrange paddle - bottom
  ;cmp #$DB
  ;bmi @EXIT
  ;cmp #$FF
  ;bpl @EXIT

  LDA ballYPosTemp
  CMP #$DB
  BCC @EXIT
  CMP #$F1
  BCS @LOSEBALL; inrange paddle killzone
  CMP #$DF
  BCS @EXIT

  LDA ballXPosTemp ;inrangex paddlex
  ADC #2
  CMP $F1
  BCS @EXIT ;right of paddle
  CMP paddleX
  BCC @EXIT ;left of paddle

  ;cmp #$E6
  ;bcs @HITPADDLESIDE Not working very well

  ;lda prevFrameBallY ;prevy high - paddle
  ;cmp #$BA
  ;bmi @EXIT
  ;cmp #$DB
  ;bpl @EXIT

  JSR SetBallSpdYUp ;Hit paddle
  LDA #$DA
  STA ballYPosTemp
  BNE @EXIT ;always branch

; @HITPADDLESIDE:
;  lda paddleX
;  adc #$10 ;Exact value doesnt matter
;  cmp ballXPosTemp
;  bpl :+
;  jsr SetBallSpdXRight
;  bcc @EXIT
; :jsr SetBallSpdXLeft
;  bcs @EXIT

 @LOSEBALL:
  LDA #$40
  STA ballXSpeedTemp
  LDA #maxBallCount
  ISC currentBallCount ;carry is set
  BNE :+

  LDA #3 ;Game lost
  BNE @CLEARGT
  
@EXIT:
  LDA ballYPosTemp
  BMI :+
  CMP #$13
  BPL :+
  LDA #4 ;Game won
 @CLEARGT:
  STA gameModeBuffer
  TSX
  STX globalTimer
  :
  
  CLC
  LDX oamBufferIndex
  LDA ballXPosTemp
  ADC $EE
  STA oamBuffer+3, X
  CLC 
  LDA ballYPosTemp
  ADC $EF
  STA oamBuffer+0, X

  ANC #0 ;clear temp ball vectors and C
  STA $EE
  STA $EF

  LDY #5
 :LDA ballTemp+2, Y
  STA (ballIndex), Y
  DEY 
  BPL :-

 DECBALLINDEX:
  LDA ballIndex
  ;clc
  SBC #6-1 ;C always clear
  BEQ :+
  JMP BALLLOOP
 :

  LDA globalTimer
  AND #%00111111
  BNE :+
  JSR IncTime
 :

  ;JMP WAITVBLANK