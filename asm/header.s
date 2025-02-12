;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
;This header follows the NES2.0 standard
  .byte $4E, $45, $53, $1A ;iNES/NES2.0 header identifier
  .byte $02                ;PRG ROM LSB: 2x 16KB
  .byte $01                ;CHR ROM LSB: 1x 8KB 
  .byte $00                ;Mapper 0 (bits 0-3), NT layout: Horizontal, Battery/Trainer not present
  .byte $08                ;Mapper 0 (bits 7-4), NES2.0 identifier, Console type: NES
  .byte $00                ;Mapper 0 (bits 11-8), Submapper 0
  .byte $00                ;PRG/CHR MSB
  .byte $00                ;PRG RAM/EEPROM: None
  .byte $00                ;CHR RAM: None
  .byte $00                ;CPU/PPU timing: RP2C02 (NTSC NES)
  .byte $00                ;Vs. System Type: N/A
  .byte $00                ;Miscellaneous ROM area: N/A
  .byte $01                ;Expansion device: Standard NES/Famicom controller