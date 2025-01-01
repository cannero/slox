import Testing
@testable import slox

func parse(_ input: [Token], _ expectedOutput: Expr) throws {
    let parser = Parser(input)
    let res = try parser.parse()

    #expect(res == expectedOutput)
}

@Test func ParseLiteralBool() throws {
    let input = [
        Token(type: .true, lexeme: "true", line: 1),
        Token(type: .eof, lexeme: "", line: 1)
    ]
    let expectedOutput = Literal(value: .bool(true))

    try parse(input, expectedOutput)
}

@Test func ParseLiteralString() throws {
    let input = [
        Token(type: .string, lexeme: "\"oewi\"", line: 1, literal: .string("oewi")),
        Token(type: .eof, lexeme: "", line: 1)
    ]
    let expectedOutput = Literal(value: .string("oewi"))

    try parse(input, expectedOutput)
}

@Test func ParseEquality() throws {
    let input = [
        Token(type: .number, lexeme: "2", line: 1, literal: .int(2)),
        Token(type: .equalEqual, lexeme: "==", line: 1),
        Token(type: .number, lexeme: "3", line: 1, literal: .int(3)),
        Token(type: .eof, lexeme: "", line: 1)
    ]
    let expectedOutput = Binary(left: Literal(value: .int(2)),
        op: Token(type: .equalEqual, lexeme: "==", line: 1),
        right: Literal(value: .int(3)))

    try parse(input, expectedOutput)
}

// @Test func ParseBinary() throws {
//     let input = [
//         Token(type: .identifier, lexeme: "a", line: 1),
//         Token(type: .plus, lexeme: "+", line: 1),
//         Token(type: .identifier, lexeme: "b", line: 1),
//         Token(type: .eof, lexeme: "", line: 1)
//     ]
//     let expectedOutput = Binary(left: (: .identifier("a")),
//         op: Token(type: .plus, lexeme: "+", line: 1),
//         right: (: .identifier("b")))

//     try parse(input, expectedOutput)
// }
