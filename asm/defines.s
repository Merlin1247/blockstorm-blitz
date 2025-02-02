.define gameStatus $00 ;7:Game ended 6: Controller disable 5:won/lost 10: (0: Main level 1: Paused 2: Main menu) 
.define level $01 ;Self-explanatory
.define globalTimer $02 ;Increments every frame, used for waiting at the end of levels
.define paddleX $03
.define ppuCtrlTracker $0F
.define cellBlockHits $0D
;.define LoadLevelData $00D0
.define LevelDataIndex $D0 ;+$D1
.define controller1 $FE
.define controller2 $FF

.define points $C0
.define time $C6

.define startingBall $10
.define startingBallXSpeed $10
.define startingBallYSpeed $11
.define startingBallXSubSpeed $12
.define startingBallYSubSpeed $13
.define startingBallXPos $14
.define startingBallYPos $15

.define ballTemp $16
.define ballXPosTemp $16
.define ballYPosTemp $17
.define ballXSpeedTemp $18
.define ballYSpeedTemp $19
.define ballXSubSpeedTemp $1A
.define ballYSubSpeedTemp $1B
.define ballXSubPosTemp $1C
.define ballYSubPosTemp $1D
;.define ballStatusTemp $BA

.define maxBallCount 25
.define currentBallCount $1E

.define prevFrameBallX $F0

.define oamBuffer $0300
.define oamBufferIndex $B5
.define ballDataPage $0600
.define ballIndex $B0 ;+B1, B2, B3
.define hitboxPage $0400
.define healthPage $0500
.define healthPageIndex $BC ;+BD
.define tempIndex $BE ;+$BF
.define blockHitBuffer $0700

.define bhbIndex $B4
.define bhbLength 17
.define bhbAddrHi blockHitBuffer
.define bhbAddrLo blockHitBuffer+bhbLength
.define bhbTileTL blockHitBuffer+bhbLength*2
.define bhbTileTR blockHitBuffer+bhbLength*3
.define bhbPaletteAddrLo blockHitBuffer+bhbLength*4
.define bhbPaletteMask blockHitBuffer+bhbLength*5
.define bhbNewPalette blockHitBuffer+bhbLength*6

.define ppuCtrl $2000
.define ppuMask $2001
.define ppuStatus $2002
.define oamAddr $2003
.define oamData $2004
.define ppuScroll $2005
.define ppuAddr $2006
.define ppuData $2007
.define oamDMA $4014