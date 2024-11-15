INFLOOP:
  ldx #0
  jsr ReadControllerInputs

  inc globalTimer

  lax gameStatus ;Check game status, if not in game, return immediately
  and #%00000011
  beq :+
  jmp WAITVBLANK
  :

  txa ;Check game end flag
  bpl NORMALFRAME
  
  and #%00100000 ;Check won/lost flag
  beq LOSTFRAME

WONFRAME:
  lda globalTimer
  bne :++
  ldx level
  inx
  cpx #levelCount
  bne :+
  ldx #0
 :stx level
  jsr LoadBackground
  lda #0
  sta gameStatus
  :jmp WAITVBLANK
LOSTFRAME:
  lda globalTimer
  bne :++
  lda level
  beq :+
  dec level
 :jsr LoadBackground
  lda #0
  sta gameStatus
  :jmp WAITVBLANK

NORMALFRAME:
  clc ;Increase ball x
  lda ballXSubPos
  adc ballXSubSpeed
  sta ballXSubPos
  lda ballXPos
  adc ballXSpeed
  sta ballXPos

  lda #$10 ;Figure out if the ball hits a horizontal wall
  cmp $04
  bcc :+
  sta $04
  jsr SetBallSpdXRight
: lda #$EB
  cmp $04
  bcs :+
  sta $04
  jsr SetBallSpdXLeft
:

  clc ;Increase ball y
  lda ballYSubPos
  adc ballYSubSpeed
  sta ballYSubPos
  lda ballYPos
  sta prevFrameBallY
  adc ballYSpeed
  sta ballYPos

  ;Move paddle left
  lda #%00000010
  and $FE
  beq :+
  lda #$10
  cmp paddleX
  beq :+
  dec paddleX
: ;Move paddle right
  lda #%00000001
  and $FE
  beq :+
  lda #$D0
  cmp paddleX
  beq :+
  inc paddleX
: 

;Block collision detection:
  lda ballXPos
  sec
  sbc #08
  lsr A
  lsr A
  lsr A
  lsr A
  ;and %00001111
  sta $F2
  lda ballYPos
  sec
  sbc #08
  and #%11110000
  ora $F2
  sta $FD
  tax ;At this point, X contains the memory location of the health of the top-leftmost block
  ldy #0
  lda healthPage, X ;top-left
  sta $F2 
  beq :+
  ldy #%11000000
: inx
  lda healthPage, X ;top-right
  sta $F3
  beq :+
  tya
  ora #%00100001
  tay
: txa
  clc
  adc #$0F
  tax
  lda healthPage, X ;bottom-left
  sta $F4
  beq :+
  tya
  ora #%00010010
  tay
: inx
  lda healthPage, X ;bottom-right
  sta $F5
  beq :+
  tya
  ora #%00001100
  tay
: tya
  and #%00110011
  asl A
  asl A
  sta $FC
  tya
  and #%11001100
  lsr A
  lsr A
  ora $FC
  sty $FC
  eor #%11111111
  and $FC
  sta $FC

.macro wallpush vertical, hitboxedge, hitboxedgeside, hitboxfront, hitboxdir, blockHit, prevSameCollisions
  .local NOHIT
  .local EXIT
  .local parallelaxis
  .local pushaxis
  .local moveBuffer
  asl $FC
  bcc NOHIT ;1
  .if vertical
    .define parallelaxis ballXPos
    .define pushaxis ballYPos
    .define moveBuffer $EF
  .else
    .define parallelaxis ballYPos
    .define pushaxis ballXPos
    .define moveBuffer $EE
  .endif
  lda parallelaxis ;2
  adc #7 ;Carry always set, so +1
  and #%00001111
  .if hitboxedgeside
    cmp #16-hitboxedge-1
    bmi NOHIT
  .else
    cmp #hitboxedge+1
    bpl NOHIT
  .endif ;3
  lax pushaxis ;3b
  clc ;could replace w/ .if hitbox edge #-1
  adc #8
  and #%00001111
  .if !hitboxdir
    cmp #hitboxfront+1
    bpl NOHIT
    cmp #hitboxfront-4
    bmi NOHIT
  .else
    cmp #hitboxfront
    bmi NOHIT
    cmp #hitboxfront+5
    bpl NOHIT
  .endif ;4
  txa
  sec
  sbc #8
  and #%11110000
  clc
  .if !hitboxdir
    adc #hitboxfront+9
  .else
    adc #hitboxfront+7
  .endif
  sec
  sbc pushaxis
  sec
  sbc moveBuffer
  sta moveBuffer ;6
  .if vertical
    .if !hitboxdir
      jsr SetBallSpdYDown
    .else
      jsr SetBallSpdYUp
    .endif
  .else
    .if !hitboxdir
      jsr SetBallSpdXRight
    .else
      jsr SetBallSpdXLeft
    .endif
  .endif ;7

  .if prevSameCollisions
    lsr $0D
    bcs EXIT
  .else
    sec
    rol $0D
  .endif

  .if blockHit = 1
    lda #$00
  .elseif blockHit = 2
    lda #$01
  .elseif blockHit = 3
    lda #$10
  .elseif blockHit = 4
    lda #$11 
  .endif

  adc $FD

  jsr HitBlock

  jmp EXIT
  NOHIT:
    .if prevSameCollisions
      lsr $0D
    .else
      clc
      rol $0D
    .endif
  EXIT:
.endmacro

  wallpush 0, 4, 0, 7, 0, 1, 0 ;AB
  wallpush 1, 5, 0, 6, 0, 1, 1 ;AC
  wallpush 0, 4, 0, 4, 1, 2, 0;BA
  wallpush 1, 5, 0, 3, 1, 3, 0;CA
  wallpush 0,10, 1, 4, 1, 4, 0;DC
  wallpush 1, 9, 1, 3, 1, 4, 1;DB
  wallpush 0,10, 1, 7, 0, 3, 1;CD
  wallpush 1, 9, 1, 6, 0, 2, 1;BD

  clc
  lda ballXPos
  adc $EE
  sta ballXPos
  clc
  lda ballYPos
  adc $EF
  sta ballYPos

  lda #0 ;clear temp ball vectors
  sta $EE
  sta $EF

  lda globalTimer
  and #%00111111
  bne :+
  jsr IncTime
 :

@WINLOSE: ;Check if the game is won or lost
  ;lda #0
  ;sta $FC

  lda ballYPos ;inrange paddle - bottom
  cmp #$DB
  bmi @EXIT
  cmp #$FF
  bpl @EXIT

  lda ballYPos ; inrange paddle killzone
  cmp #$DB
  bmi :+
  cmp #$E4
  bpl :+

  lda ballXPos ;inrangex paddlex
  cmp paddleX
  bmi @EXIT
  cmp $F1
  bpl @EXIT

  lda prevFrameBallY ;prevy high - paddle
  cmp #$BA
  bmi @EXIT
  cmp #$DB
  bpl @EXIT

  jsr SetBallSpdYUp ;Hit paddle
  lda #$DB
  sta ballYPos
  jmp @EXIT

: lda #%10000000 ;Game lost
  sta gameStatus
  lda #0
  sta globalTimer
  
@EXIT:
  lda ballYPos
  bmi :+
  cmp #$13
  bpl :+
  lda #%10100000 ;Game won
  sta gameStatus
  lda #0
  sta globalTimer
  :

WAITVBLANK:
  lda gameStatus
  ora #%01000000
  sta gameStatus
: bit gameStatus
  bvs :-
  jmp INFLOOP