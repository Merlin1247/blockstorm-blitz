;Copyright (C) 2025 Brandon W. See blockstormblitz.s for more information.
  .define useSquareTiles 0
  .if !useSquareTiles
    .incbin "chr\default.chr"
  .else
    .incbin "chr\squares.chr"
  .endif