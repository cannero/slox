class Environment {
    private var values = Dictionary<String, NameValue>()
    private let enclosing: Environment?

    init() {
        enclosing = nil
    }

    init(enclosing: Environment) {
        self.enclosing = enclosing
    }

    func define(name: String, value: ResultValue?) {
        values[name] = value == nil ? .noValue : .of(value!)
    }

    func get(name: Token) throws -> ResultValue {
        guard case let .of(value) = values[name.lexeme] else {
            if case .noValue = values[name.lexeme] {
                throw RuntimeError(name, "Variable '\(name.lexeme)' has no value assigned.")
            }
            
            guard let enclosing = enclosing else {
                throw RuntimeError(name, "Undefined variable '\(name.lexeme)'.")
            }

            return try enclosing.get(name: name)
        }

        return value
    }

    func assign(name: Token, value: ResultValue) throws {
        guard values[name.lexeme] != nil else {
            guard let enclosing = enclosing else {
                throw RuntimeError(name,
                    "Undefined variable '\(name.lexeme)'.")
            }

            return try enclosing.assign(name: name, value: value)
        }

        values[name.lexeme] = .of(value)
    }

    private enum NameValue {
        case noValue
        case of(ResultValue)
    }
}
