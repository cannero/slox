class Scanner {
    let source: String
    var startIndex: String.Index
    var currentIndex: String.Index
    var currentLine: Int = 1
    var tokens: [Token] = []

    init(_ source: String) {
        self.source = source
        self.startIndex = source.startIndex
        self.currentIndex = source.startIndex
    }

    func scanTokens() -> [Token] {
        tokens.removeAll()
        while !isAtEnd {
            startIndex = currentIndex
            scanToken()
        }

        tokens.append(Token(type: .eof, lexeme: "", line: currentLine))
        return tokens
    }

    private func scanToken() {
        let char = advance()
        switch char {
        case "(": addToken(.leftParen)
        case ")": addToken(.rightParen)
        case "{": addToken(.leftBrace)
        case "}": addToken(.rightBrace)
        case ",": addToken(.comma)
        case ".": addToken(.dot)
        case "-": addToken(.minus)
        case "+": addToken(.plus)
        case ";": addToken(.semicolon)
        case "*": addToken(.star)
        default:
            error(currentLine, "unknown char \(char)")
        }
    }

    private func advance() -> Character {
        let char = source[currentIndex]
        currentIndex = source.index(after: currentIndex)
        return char
    }

    private func addToken(_ type: TokenType) {
        tokens.append(Token(type: type, lexeme: currentLexeme, line: currentLine))
    }

    private var currentLexeme: String {
        return String(source[startIndex..<currentIndex])
    }

    private var isAtEnd: Bool {
        currentIndex >= source.endIndex
    }
}
