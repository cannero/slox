public func run(source: String) throws {
    let scanner = Scanner(source)
    let tokens = scanner.scanTokens()
    if scanner.errorDuringScanning() {
        print("errors, quiting")
        return
    }
    let parser = Parser(tokens)
    let stmts = try parser.parse()

    let interpreter = Interpreter()
    try interpreter.interpret(statements: stmts)
    //print(result)
    // for token in tokens {
    //     print(token)
    // }
}

func error(_ line: Int, _ message: String) {
    report(line, "", message)
}

func report(_ line: Int, _ location: String, _ message: String) {
    print("[line \(line)]: Error\(location): \(message)")
}

func error(at token: Token, message: String) {
    if token.type == .eof {
        report(token.line, " at end", message)
    } else {
        report(token.line, " at '\(token.lexeme)'", message)
    }
}

func runtimeError(error: RuntimeError) {
    print("[line \(error.token?.line ?? 0)]: \(error.message)")
}
