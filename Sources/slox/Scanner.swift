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
        case "!": addToken(match("=") ? .bangEqual : .bang)
        case "=": addToken(match("=") ? .equalEqual : .equal)
        case "<": addToken(match("=") ? .lessEqual : .less)
        case ">": addToken(match("=") ? .greaterEqual : .greater)
        case "/":
            if match("/") {
                while peek() != "\n" && !isAtEnd {
                    _ = advance()
                }
            } else {
                addToken(.slash)
            }
        case " ", "\r", "\t": break
        case "\n":
            currentLine += 1
        case "\"": readString()
        case _ where char.isDigit: readNumber()
        case _ where char.isLetter: readIdentifier()
        default:
            error(currentLine, "unknown char \(char)")
        }
    }

    private func advanceIndex() {
        currentIndex = source.index(after: currentIndex)
    }

    private func advance() -> Character {
        let char = source[currentIndex]
        advanceIndex()
        return char
    }

    private func addToken(_ type: TokenType, _ literal: Any? = nil) {
        tokens.append(Token(type: type, lexeme: currentLexeme, line: currentLine, literal: literal))
    }

    private func match(_ char: Character) -> Bool {
        guard !isAtEnd, source[currentIndex] == char else {
            return false
        }

        advanceIndex()
        return true
    }

    private func peek() -> Character? {
        guard !isAtEnd else {
            return nil
        }

        return source[currentIndex] 
    }

    private func readString() {
        while peek() != "\"" && !isAtEnd {
            if peek() == "\n" {
                currentLine += 1
            }

            _ = advance()
        }

        if isAtEnd {
            error(currentLine, "Unterminated string")
            return
        }

        let strValue = currentLexeme.dropFirst()
        // closing "
        _ = advance()
        
        addToken(.string, strValue)
    }

    // only integers
    private func readNumber() {
        while peek()?.isDigit == true {
            _ = advance()
        }

        addToken(.number, Int(currentLexeme)!)
    }

    private func readIdentifier() {
        while peek()?.isLetter == true || peek()?.isNumber == true || peek() == "_" {
            _ = advance()
        }

        if let type = TokenType.keywordOrNil(word: currentLexeme) {
            addToken(type)
        } else {
            addToken(.identifier)
        }
    }

    private var currentLexeme: String {
        return String(source[startIndex..<currentIndex])
    }

    private var isAtEnd: Bool {
        currentIndex >= source.endIndex
    }
}

private extension Character
{
    var isDigit: Bool { return "0"..."9" ~= self }
}
