  .define useSquareTiles 0
  .if !useSquareTiles
    .incbin "chr\default.chr"
  .else
    .incbin "chr\squares.chr"
  .endif