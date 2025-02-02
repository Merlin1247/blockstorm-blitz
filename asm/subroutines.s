ReadControllerInputs:
  LDY #1 
  STY controller1, X ;Initialize output memory
  STY $4016
  DEY
  STY $4016 ;Send a pulse to the 4021
  READLOOP:
    LDA $4016
    LSR A
    ROL controller1, X
    BCC READLOOP
  RTS
  
SetBallSpdXLeft:
  LDA ballXSpeedTemp
  BMI :++
FlipBallSpdX:
  EOR #%11111111
  TAY
  LDA ballXSubSpeedTemp
  EOR #%11111111
  TAX
  INX
  STX ballXSubSpeedTemp
  BNE :+
  INY
 :STY ballXSpeedTemp
 :RTS

SetBallSpdXRight:
  LDA ballXSpeedTemp
  BPL :++
  EOR #%11111111
  TAY
  LDA ballXSubSpeedTemp
  EOR #%11111111
  TAX
  INX
  STX ballXSubSpeedTemp
  BNE :+
  INY
 :STY ballXSpeedTemp
 :RTS

SetBallSpdYUp:
  LDA ballYSpeedTemp
  BMI :++
  EOR #%11111111
  TAY
  LDA ballYSubSpeedTemp
  EOR #%11111111
  TAX
  INX
  BNE :+
  INY
 :STY ballYSpeedTemp
  STX ballYSubSpeedTemp
 :RTS

SetBallSpdYDown:
  LDA ballYSpeedTemp
  BPL :++
  EOR #%11111111
  TAY
  LDA ballYSubSpeedTemp
  EOR #%11111111
  TAX
  INX
  BNE :+
  INY
 :STY ballYSpeedTemp
  STX ballYSubSpeedTemp
 :RTS

;minus to plus conversion ex:
;%00000001.000000001 -->
;%11111110.111111111
;%00000101.100000001 -->
;%11111010.011111111
;%00000010.100000000 -->
;%11111101.100000000

NewBall:
  CLC ;?
  LDA #maxBallCount*4+4 ;Avoid sprite 0
 :SBC #4-1
  TAX
  LDY oamBuffer, X
  CPY #$F1
  BCC :-
  STA ballIndex+2
  LSR A ;16-4
  ADC ballIndex+2 ;carry always clear ;12
  BEQ :-- ;RTS of prev. sub
  STA ballIndex+2
  LDA startingBallYPos
  STA oamBuffer, X
  LDA startingBallXPos
  STA oamBuffer+3, X
  LDY #3
 :LDA startingBall, Y
  STA (ballIndex+2), Y
  DEY
  BPL :-
  DEC currentBallCount
  RTS

DrawText:
  STA tempIndex+1
  STX tempIndex
  LAX ppuCtrlTracker
  AND #%11111011
  STA ppuCtrl
  LDY #0
  LDA (tempIndex), Y
  TAY
  LDA (tempIndex), Y
  STA ppuAddr
  DEY
  LDA (tempIndex), Y
  STA ppuAddr
  DEY
 :LDA (tempIndex), Y
  BEQ :+
  STA ppuData
  BNE :++
 :LDA ppuData
 :DEY
  BNE :---
  STX ppuCtrl
  STY ppuScroll
  STY ppuScroll
  RTS

DrawHUD:
  LDX #<FIRSTLINE
  LDA #>FIRSTLINE
  JSR DrawText

 ;Level count
  LDY level
  INY
  JSR HexToDec255
  LDA #$20 
	STA ppuAddr
  LDA #$30 
	STA ppuAddr
  TXA
  ADC #$D1
  STA ppuData
  LDA $F5
  ADC #$D1
  STA ppuData
  RTS

HexToDec255:
  TYA                         ; A = 0-255
  LDY    #0
  CMP    #100
  BCC    @DONE100
  INY
  SBC    #200
  BCC    @USE100
  INY                          ; If a mapper conflicts with SBC #-101 (becomes BIT $9BE9), then you can try:
  .byte $2C                    ; - 'BNE .done100' instead of .byte $2C, as Y=2 or Y=$32 at this point...
@USE100:
  ADC    #100                 ; - substitute with SBC #-101 with ADC #100 (which would become BIT $6469) 
@DONE100:                        
  LDX    #0
  CMP    #50                   
  BCC    @TRY20
  SBC    #50
  LDX    #5
  BNE    @TRY20               ; always branch
@DIV20:
  INX
  INX
  SBC    #20
@TRY20:
  CMP    #20
  BCS    @DIV20
@TRY10:
  CMP    #10
  BCC    @FINISHED
  SBC    #10
  INX
@FINISHED:
  STY $F3 ; Y = DECimal hundreds
  STX $F4 ; X = DECimal tens
  STA $F5 ; A = DECimal ones
  CLC
  RTS

HitBlock:
  ADC $FD
  TAX
  STA $F0
  AND #%00110000
  STA $F1
  LDA #1
  DEC healthPage, X
  BNE :+
  CLV
  JSR UpdateHitbox
  DEX
  JSR UpdateHitbox
  TXA
  AXS #$0F ;carry does not affect result. Also overflow flag is unchanged
  JSR UpdateHitbox
  DEX
  JSR UpdateHitbox
  LDA #5
 :LDX #5
  JSR AddPoints
  LAX $F0
  AND #%00001111
  SLO $F1
  ASL A
  STA $F1
  TXA
  AND #%11000000
  ROL A ;Carry always clear
  ROL A
  ROL A
  ADC #$20
  STA $F0
  LDY healthPage, X

LoadBlock: ; y = health,  
  ;LDA ppuSTAtus ;read PPU status to reset high/low latch
  TYA ;cpy #0 ;could remove?
  STA $F9 ;Find current case
  BEQ @CASE0
  CMP #100
  BEQ @CASE100
  
  JSR HexToDec255+1 ;Generic 1-99, skip tya
  LDA #$10
  ADC $F4
  STA $F6
  LDX #0
  CMP #$13
  BMI :+
  CLC
  LDX #$20

: TXA
  ADC #$30
  ADC $F5
  STA $F7
  JMP :+
  
 @CASE0:
  LDA #$1A
  STA $F6
  STA $F7
  JMP :+

 @CASE100:
  LDX #$1E
  STX $F6
  INX
  STX $F7

: JSR SetTilePalette ;Y still contains index

 @LOADTILEDATA:
  LDA $F1
  STA bhbAddrLo, Y
  LDA $F6
  STA bhbTileTL, Y
  LDA $F7
  STA bhbTileTR, Y
  LDA $F0
  BVC :+
  JMP SingleStore
 :STA bhbAddrHi, Y
  RTS

SetTilePalette:
  ;bit 6 F1 (64) 2 lines
  ;bit 1 F1 (2) 
  LAX $F1
  ASL A
  ASL A ;bit 6 in carry
  TXA
  AND #%00000010
  ADC #0
  TAY
  
  ;BITS 987432 0F NT ADDR
  TXA
  ASL A
  LDA $F0
  AND #%00000011
  ROL A
  ASL A
  ASL A
  ;ASL A
  STA $FA

  TXA
  ALR #%00011100
  LSR A
  SLO $FA
  ORA #$C0
  PHA
  LDX ATTRIBUTEMASK, Y ;33


;  LDA $F0
;  AND #%00000011
;  ASL A
;  ASL A
;  STA $FA
;  LDA $F1
;  AND #%10000000 ;make sure carry is reset if needed ;%11100000
;  ROL A
;  ROL A
;  ROL A
;  ROL A ; high bits of F1
;  SLO $FA
;  ;AND #%11111100
;  ASL A
;  STA $FB
;  LAX $F1 
;
;  AND #%01000000
;  ASL A
;  ;LDA #%10000000
;  ;rla $F1
;  ROL A
;  ROL A
;  ;ROL A
;  STA $FA
;  TXA
;  ALR #%00000010
;  SLO $FA
;  TAY ;Get the correct position for the mask of the attribute byte + 1
;
;  TXA
;  ;AND #%00011111
;  ;AND #%11111100
;  ;ror A 
;  ARR #%00011100
;  LSR A
;  ADC #$C0
;  ADC $FB
;  PHA ;attribute low byte
;
;  ANC #%10000000 ;Get default mask
; :ROL A
;  ROL A
;  DEY
;  BPL :- ;Correct mask for the attribute byte in accumulator
;  TAX

  LDA #0
  LDY $F9 ;Binary search?
  ;1-5-10-20-30-50-70-90
  ;check 10-69,add bits
  ;check 5-19, 50-89,add bits
  CPY #10
  BMI :+
  CPY #69+1
  BPL :+
  ORA #%10101010
 :CPY #5
  BMI :+
  CPY #19+1
  BPL :+
  ORA #%01010101
 :CPY #50
  BMI :+
  CPY #89+1
  BPL :+
  ORA #%01010101
  :

  SAX $FB
  TXA
  EOR #%11111111
  TAX

  BIT gameStatus
  BVS @LOAD1
  DEC bhbIndex
  LDY bhbIndex
  BNE @STOREPALETTE
  LDA gameStatus
  ORA #%01000000
  STA gameStatus
 @WAITLOOP:
  BIT gameStatus
  BVS @WAITLOOP
  LDY #bhbLength-1
  STY bhbIndex
  .byte $0C ;nop $A001
 @LOAD1:
  LDY #1

 @STOREPALETTE:
  CLC ;could remove?
  PLA
  STA bhbPaletteAddrLo, Y
  TXA
  STA bhbPaletteMask, Y
  LDA $FB
  STA bhbNewPalette, Y
  RTS

AddPoints: ;x= adding byte a = value (0-10)
  CLC
 @ADDLOOP:
  ADC points, X
  BCC :+ ;n always set
  ADC #$F6-1 ;carry is set
  STA points, X
  LDA #1
  CLC
  DEX
  BPL @ADDLOOP
  LDX #5
  LDA #$FF
 @MAXLOOP:
  DEX
 :STA points, X
  BPL @MAXLOOP
  CPX #4
  BCS :+
  JSR NewBall
 :RTS

IncTime: ;increment time; inline?
  LDX #3
  LDA #$F6
 @ADDLOOP:
  INC time, X
  BNE :+
  STA time, X
  DEX
  BPL @ADDLOOP
  LDX #3
  LDA #$FF
 @MAXLOOP:
  STA time, X
  DEX
  BPL @MAXLOOP
 :RTS