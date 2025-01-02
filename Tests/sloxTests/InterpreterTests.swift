import Testing
@testable import slox

func interpret(_ input: Expr, _ expectedOutput: ResultValue) throws {
    let interpreter = Interpreter()
    let res = try interpreter.evaluate(input)

    #expect(res == expectedOutput)
}

@Test func InterpretLiteralString() throws {
    let input = Literal(value: .string("oewi"))
    let res = ResultValue.string("oewi")

    try interpret(input, res)
}

@Test func InterpretEquality() throws {
    let input = Binary(left: Literal(value: .int(2)),
        op: Token(type: .equalEqual, lexeme: "==", line: 1),
        right: Literal(value: .int(3)))
    let res = ResultValue.bool(false)

    try interpret(input, res)
}
