enum TokenType {
    // Single-character tokens.
    case leftParen, rightParen, leftBrace, rightBrace,
    comma, dot, minus, plus, semicolon, slash, star,

    // one or two character tokens.
    bang, bangEqual,
    equal, equalEqual,
    greater, greaterEqual,
    less, lessEqual,
  
    // literals.
    identifier, `string`, number,
  
    // keywords.
    and, `class`, `else`, `false`, fun, `for`, `if`, `nil`, or,
    print, `return`, `super`, this, `true`, `var`, `while`,
  
    eof

    static func keywordOrNil(word: String) -> TokenType? {
        return switch word {
            case "and": .and
            case "class": .class
            case "else": .else
            case "false": .false
            case "fun": .fun
            case "for": .for
            case "if": .if
            case "nil": .nil
            case "or": .or
            case "print": .print
            case "return": .return
            case "super": .super
            case "this": .this
            case "true": .true
            case "var": .var
            case "while": .while
            default:
                nil
        }
    }
}
