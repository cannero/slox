enum ParseError: Error {
    case invalidSyntax
}

class Parser {
    let tokens: [Token]
    var currentToken = 0

    init(tokens: [Token]) {
        self.tokens = tokens
    }

    func parse() throws -> Expr? {
        do {
            return try expression();
        } catch ParseError.invalidSyntax {
            return nil;
        }
    }

    private func expression() throws -> Expr {
        try equality()
    }

    private func equality() throws -> Expr {
        var expr = try comparison()

        while match(.bangEqual, .equalEqual) {
            let op = previous
            let right = try comparison()
            expr = Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func comparison() throws -> Expr {
        var expr = try term()
        while match(.greater, .greaterEqual, .less, .lessEqual) {
            let op = previous
            let right = try term()
            expr = Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func term() throws -> Expr {
        var expr = try factor();

        while match(.minus, .plus) {
            let op = previous
            let right = try factor()
            expr = Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func factor() throws -> Expr {
        var expr = try unary();

        while match(.slash, .star) {
            let op = previous
            let right = try unary()
            expr = Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func unary() throws -> Expr {
        if match(.bang, .minus) {
            let op = previous
            let right = try unary()
            return Unary(op: op, right: right)
        }

        return try primary()
    }

    private func primary() throws -> Expr {
        if match(.false) {
            return Literal(value: false)
        }

        if match(.true) {
            return Literal(value: true)
        }

        if match(.nil) {
            return Literal(value: nil)
        }

        if match(.number, .string) {
            return Literal(value: previous.literal);
        }

        if match(.leftParen) {
            let expr = try expression()
            _ = try consume(.rightParen, "Expect ')' after expression.")
            return Grouping(expression: expr)
        }

        throw error(peek, "Expect expression.")
    }

    private func synchronize() {
        advance();

        while !isAtEnd {
            if previous.type == .semicolon {
                return
            }

            if [.class, .fun, .var, .for, .if, .while,
                .print, .return].contains(peek.type) {
                return
            }

            advance()
        }
    }

    private func match(_ types: TokenType...) -> Bool {
        for type in types {
            if check(type) {
                advance()
                return true
            }
        }

        return false
    }

    private func check(_ type: TokenType) -> Bool {
        if isAtEnd {
            return false
        }

        return peek.type == type
    }

    private func advance() {
        if !isAtEnd {
            currentToken += 1
        }
    }

    private func consume(_ type: TokenType, _ message: String) throws -> Token {
        if check(type) {
            advance()
            return previous
        }

        throw error(peek, message);
    }

    private func error(_ token: Token, _ message: String) -> ParseError {
        slox.error(at: token, message: message)
        return ParseError.invalidSyntax
    }

    private var isAtEnd: Bool {
        peek.type == .eof
    }

    private var peek: Token {
        tokens[currentToken]
    }

    private var previous: Token {
        tokens[currentToken - 1]
    }
}
