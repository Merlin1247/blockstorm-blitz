.define gameStatus $00 ;7:Game ended 6: Controller disable 5:won/lost 10: (0: Main level 1: Paused 2: Main menu) 
.define level $01 ;Self-explanatory
.define globalTimer $02 ;Increments every frame, used for waiting at the end of levels
.define paddleX $03
.define LoadLevelData $00D0
.define blockHitBuffer $E0
.define controller1 $FE

.define points $C0
.define time $C6

.define ballXPos $04
.define ballYPos $05
.define ballXSubPos $06
.define ballYSubPos $07
.define ballXSpeed $08
.define ballYSpeed $09
.define ballXSubSpeed $0A
.define ballYSubSpeed $0B
.define prevFrameBallY $F0

.define oamBuffer $0200
.define healthPage $0700

.define ppuCtrl $2000
.define ppuMask $2001
.define ppuStatus $2002
.define oamAddr $2003
.define oamData $2004
.define ppuScroll $2005
.define ppuAddr $2006
.define ppuData $2007
.define oamDMA $4014

.define opcodeLDAnnnnX $BD
.define opcodeSTAnnnnY $99
.define opcodeJMPnnnn $4C
.define opcodeRTS $60