LoadBackground: ;Display static background elements
  SEI ;Disable interrupts
  LAX #0
  STX ppuCtrl
  STX ppuCtrlTracker
  TAY
  STY ppuMask ;Disable NMI + Rendering
  ;Clear PPU memory + page 7
  LDA #$20
  STA ppuAddr
  STY ppuAddr

@LOOPPPU:
  LDA #$40
  STA ballDataPage, Y
  LDA #$FF
  STA oamBuffer, Y
  STX ppuData
  STX ppuData
  STX ppuData
  STX ppuData
  .byte $9E, $00, >hitboxPage ;SHX $0400, Y
  .byte $9E, $00, >healthPage ;SHX $0500, Y
  INY
  BNE @LOOPPPU

 :.byte $9C, $02, >oamBuffer ;SHY
  AXS #4 ;A is still $FF
  BNE :-

  LDA #$DD ;loop
  STA oamBuffer+$80
  STA oamBuffer+$84
  STA oamBuffer+$88
  STA oamBuffer+$8C

  LDX #$03
  STX oamBuffer+$85
  INX ;4
  STX oamBuffer+$89
  STX oamBuffer+$8D
  INX ;5
  STX oamBuffer+$81

  JSR DrawHUD

  LDY #%00010100
  STY ppuCtrl
  STY ppuCtrlTracker

  ;Display sidebars
  LDA #$1E
  LDX #$20
 :CLC
  STX ppuAddr
  STA ppuAddr
  ORA #%10100000 ;Could remove and use X instead
  LDY #$1E
 :STA ppuData 
  DEY 
  BNE :-
  ADC #1 
  AND #%00011111
  CMP #2
  BNE :--

;  ldx #$1F ;Smaller version that also wipes rest of nametable. CHR needs to be rearranged tho
;  lda #$20 ;-1 byte if A is $FF
; :sta ppuAddr
;  stx ppuAddr
;  ldy #$18
; :stx ppuData
;  dey
;  bne :-
;  dex
;  bpl :--
  
  ;Display blocks
  LDY level

  LDA LEVELDATAINDEXHI, Y
  STA LevelDataIndex+1
  LDA LEVELDATAINDEXLO, Y
  STA LevelDataIndex

  ;is ball data clear?

  LDA #maxBallCount
  STA currentBallCount
  
  ;lda ppuStatus ;Reset $2006 latch
  LDY #5

 :LDA (LevelDataIndex), Y
  STA startingBall, Y
  DEY
  BPL :-

  JSR NewBall

  ;ballXSpeed $0606
  ;ballYSpeed $0607
  ;ballXSubSpeed $0608
  ;ballYSubSpeed $0609
  ;ballXPos $0707
  ;ballYPos $0704

  LDY #6

  LDA (LevelDataIndex), Y
@LOOP:
  BMI @LINE
@ONEBLOCK:
  STA $E0
  INY
  LAX (LevelDataIndex), Y
  LDA $E0
  STA healthPage, X
  TXA
  ROL A
  ROL A
  ROL A
  AND #%00000011
  ORA #%00100000
  STA $F0
  TXA 
  AND #%00110000
  ASL A ;Clears carry
  ;asl A ;test
  STA $F1
  TXA
  AND #%00001111
  ASL A
  SLO $F1
  STA $F1
  LDA $E0
  STY $E0
  JSR LoadBlock+1
  LDY $E0
  JMP @END
@LINE:
  TAX
 @LOADNAMETABLEPOS:
  AND #%00000011 ;anc?
  ORA #%00100000
  ;sta ppuAddr
  STA $F0
  TXA
  AND #%01100000
  LSR A
  STA healthPageIndex
  SEC
  ROL A ;Set bit 0
  ASL A
  ;ora #%00000010
  ;sta ppuAddr
  STA $F1
  TXA
  AND #%00000011
  ROR A
  ROR A
  ROR A
  ORA healthPageIndex
  ORA #%00000001 ;Add 1
  STA healthPageIndex

  TXA
 @BRANCH:
  AND #%00001100
  BEQ @LINE8BPT
  EOR #%00000100
  BEQ @LINE1BPT
  EOR #%00001100
  BEQ @LINEMODE3
 @LINEMODE2:
  
  JMP @LOAD
 @LINEMODE3:
  
  JMP @LOAD
 @LINE1BPT:
  ;Format: 7-mirror mode 0-6-data1(reverse), 0-6-data2(normal)?, 7-double mode 6-0-val1, 6-0-val2?
  ;BITDATA
  INY
  LDA (LevelDataIndex), Y
  STA $F4
  BMI @MIRROR
  INY
  LDA (LevelDataIndex), Y
  @MIRROR:
  ASL A ;Prep value
  STA $F3
  ;HEALTH
  LDX #0
  INY
  LDA (LevelDataIndex), Y
  BPL @ROTATEDATA
  ;DOUBLE
  AND #%01111111
  TAX
  INY
  LDA (LevelDataIndex), Y
  @ROTATEDATA:
  STY $D4
  LDY #6
 :ASL $F3
  STX $E0, Y
  BCC :+
  STA $00E0, Y
 :DEY
  BPL :--
  LDY #6
 :LSR $F4
  STX $E7, Y
  BCC :+
  STA $00E7, Y
 :DEY
  BPL :--
  JMP @LOAD +2
 @LINE8BPT:
  LDX #$0D
 :INY
  LDA (LevelDataIndex), Y
  STA $E0, X
  DEX
  BPL :-
  ;jmp @LOAD
 @LOAD:
  STY $D4
  JSR LoadBlockRow
  LDY $D4
@END:
  INY
  LDA (LevelDataIndex), Y
  BEQ @HBUPDATEALL
  JMP @LOOP
 @HBUPDATEALL:
  ;New version with registers shuffled
  BIT $00 ;Set overflow (Necessary?)
  LDX #$CF
UpdateHitbox:
  LDA healthPage, X
  BEQ :+
  LDA #%11000000
 :LDY healthPage+1, X
  BEQ :+
  ORA #%00100001
 :LDY healthPage+$10, X
  BEQ :+
  ORA #%00010010
 :LDY healthPage+$11, X
  BEQ :+
  ORA #%00001100
 :STA $FB
  AND #%00110011
  ASL A
  STA $FA
  LDA $FB
  ALR #%11001100
  LSR A
  SLO $FA
  EOR #%11111111
  AND $FB
  STA hitboxPage, X

  BVC @RTS

  DEX
  CPX #$1F ;Doing it this way saves time in frame logic
  BNE UpdateHitbox

 @FINISH:
 ;Finish loading
 :BIT ppuStatus
  BPL :-
  STY ppuScroll
  STY ppuScroll
  ;lda ppuStatus
  LDA #%10010100 ;ppuData set to $20, needed for vblank
  STA ppuCtrl ;When VBLANK occurs call NMI
  STA ppuCtrlTracker
  LDA #%00011110
  STA ppuMask ;show sprites and background
  ;Setting sprite range
  LDA #>oamBuffer
  STA oamDMA
  LDX #3
  LDY #$F6
 :STY time, X 
  DEX
  BPL :-
  
  CLI ;Enable interrupts
 @RTS:
  RTS

LoadBlockRow: ;E0-ED: Block health
  ;sta healthPageIndex+1
  LDX #13 
  CLC
 @LOOP:
  STX $DB
  LDA #13+1 ;carry clear
  SBC $DB
  TAY
  LDA $E0, X
  STA (healthPageIndex), Y
  JSR LoadBlock+1 ;skip tya
  INC $F1
  INC $F1
  LDX $DB
  DEX
  BPL @LOOP
  RTS