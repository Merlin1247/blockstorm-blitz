;Copyright (C) 2025 Brandon W.
;This program is free software: you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation, either version 3 of the License, or
;(at your option) any later version.
;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;You should have received a copy of the GNU General Public License
;along with this program.  If not, see <https://www.gnu.org/licenses/>.

.setcpu "6502X"

.segment "HEADER"
  .include "asm\header.s"

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