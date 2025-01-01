struct RuntimeError : Error {
    let token: Token?
    let message: String

    init(_ message: String) {
        self.token = nil
        self.message = message
    }

    init(_ token: Token, _ message: String) {
        self.token = token
        self.message = message
    }

    static func notANumber(_ token: Token) -> RuntimeError {
        RuntimeError(token, "Operand(s) must be a number(s)")
    }
}
