struct Token: Equatable {
    let type: TokenType
    let lexeme: String
    // let literal: TODO
    let line: Int

}

extension Token: CustomStringConvertible {
    var description: String {
        return "\(type) \(lexeme)"
    }
}
