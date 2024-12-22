struct Token: Equatable {
    let type: TokenType
    let lexeme: String
    let literal: Any?
    let line: Int

    init(type: TokenType, lexeme: String, line: Int, literal: Any? = nil) {
        self.type = type
        self.lexeme = lexeme
        self.line = line
        self.literal = literal
    }

    static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.type == rhs.type &&
               lhs.lexeme == rhs.lexeme &&
               lhs.line == rhs.line
    }
}

extension Token: CustomStringConvertible {
    var description: String {
        return "\(type) \(lexeme) \(literal ?? "")"
    }
}
