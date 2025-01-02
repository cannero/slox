import Testing
@testable import slox

func parse(_ input: inout [Token], _ output: Expr, _ lastLine: Int = 1) throws {
    input.append(contentsOf: [
        Token(type: .semicolon, lexeme: ";", line: lastLine),
        Token(type: .eof, lexeme: "", line: lastLine),
    ])
    let expectedOutput = [Expression(expression: output)]
    let parser = Parser(input)
    let res = try parser.parse()

    #expect(res == expectedOutput)
}

@Test func ParseLiteralBool() throws {
    var input = [
        Token(type: .true, lexeme: "true", line: 1),
    ]
    let expectedOutput = Literal(value: .bool(true))

    try parse(&input, expectedOutput)
}

@Test func ParseLiteralString() throws {
    var input = [
        Token(type: .string, lexeme: "\"oewi\"", line: 1, literal: .string("oewi")),
    ]
    let expectedOutput = Literal(value: .string("oewi"))

    try parse(&input, expectedOutput)
}

@Test func ParseEquality() throws {
    var input = [
        Token(type: .number, lexeme: "2", line: 1, literal: .int(2)),
        Token(type: .equalEqual, lexeme: "==", line: 1),
        Token(type: .number, lexeme: "3", line: 1, literal: .int(3)),
    ]
    let expectedOutput = Binary(left: Literal(value: .int(2)),
        op: Token(type: .equalEqual, lexeme: "==", line: 1),
        right: Literal(value: .int(3)))

    try parse(&input, expectedOutput)
}

// @Test func ParseBinary() throws {
//     var input = [
//         Token(type: .identifier, lexeme: "a", line: 1),
//         Token(type: .plus, lexeme: "+", line: 1),
//         Token(type: .identifier, lexeme: "b", line: 1),
//     ]
//     let expectedOutput = Binary(left: (: .identifier("a")),
//         op: Token(type: .plus, lexeme: "+", line: 1),
//         right: (: .identifier("b")))

//     try parse(&input, expectedOutput)
// }
