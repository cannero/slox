struct Token: CustomStringConvertible {
    let type: TokenType
    let lexeme: String
    // let literal: TODO
    let line: Int

    var description: String {
        return "\(type) \(lexeme)"
    }
}
