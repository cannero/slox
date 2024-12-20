enum TokenType {
  // Single-character tokens.
  case left_paren, right_paren, left_brace, right_brace,
  comma, dot, minus, plus, semicolon, slash, star,

  // one or two character tokens.
  bang, bang_equal,
  equal, equal_equal,
  greater, greater_equal,
  less, less_equal,

  // literals.
  identifier, `string`, number,

  // keywords.
  and, `class`, `else`, `false`, fun, `for`, `if`, `nil`, or,
  print, `return`, `super`, this, `true`, `var`, `while`,

  eof
}