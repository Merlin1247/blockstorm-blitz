.segment "HEADER"
  .byte $4E, $45, $53, $1A ;iNES header identifier
  .byte $02                ;2x 16KB PRG code
  .byte $01                ;1x 8KB CHR data
  .byte $00                ;No mapping or mirroring
  .byte $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00 

.segment "VECTORS"
  .word NMI
  .word RESET
  .word IRQ

.segment "MACROS"
  .include "asm\defines.s"
  .include "asm\macros.s"
  .include "level\levelData.offsets.s"

.segment "STARTUP"

RESET:
.include "asm\startup.s"

.include "asm\frame.s"

NMI: ;Non Maskable Interrupt handler, called during VBLANK
.include "asm\vblank.s"

IRQ: ;Interrupt request handler
.include "asm\irqs.s"

.include "asm\subroutines.s"

.include "asm\loadlevel.s"

.include "asm\datatables.s"

LEVELDATAINDEXHI:
.hibytes LEVELDATAINDICES

LEVELDATAINDEXLO:
.lobytes LEVELDATAINDICES

LD:
;Data format: Bit 7 L --> single block. 6-0 = health (health 0 = list terminator). Next byte: 7-4 = y, 3-0 = x
;             Bit 7 H --> line of blocks. 
.incbin "level\levelData.lvl"

; Character memory
.segment "CHARS"
  .include "asm\chars.s"