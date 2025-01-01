import Testing
@testable import slox

func scan(_ source: String, _ expectedOutput: [Token]) {
    let scanner = Scanner(source)
    
    let res = scanner.scanTokens()

    #expect(res == expectedOutput)
    #expect(scanner.errorDuringScanning() == false)
}

@Test func ScanOpenBrace() {
    let source = "{"
    let expectedOutput = [
        Token(type: .leftBrace, lexeme: "{", line: 1),
        Token(type: .eof, lexeme: "", line: 1)]

    scan(source, expectedOutput)
} 

@Test func ScanBangEqual() {
    let source = "!="
    let expectedOutput = [
        Token(type: .bangEqual, lexeme: "!=", line: 1),
        Token(type: .eof, lexeme: "", line: 1)]
    scan(source, expectedOutput)
}

@Test func ScanCommentAndSlash() {
    // this linebreak does not behave like when read from a file,
    // then CRLF is one character
    let source = """
    // this is a comment

    /
    """
    let expectedOutput = [
        Token(type: .slash, lexeme: "/", line: 3),
        Token(type: .eof, lexeme: "", line: 3)]
    scan(source, expectedOutput)
}

@Test func ScanString() {
    let source = " \"this is a string\" "

    let expectedOutput = [
        Token(type: .string, lexeme: "\"this is a string\"", line: 1),
        Token(type: .eof, lexeme: "", line: 1)]
    scan(source, expectedOutput)
}

@Test func ScanIdentifier() {
    let source = "no_1️⃣ = 3"

    let expectedOutput = [
        Token(type: .identifier, lexeme: "no_1️⃣", line: 1),
        Token(type: .equal, lexeme: "=", line: 1),
        Token(type: .number, lexeme: "3", line: 1),
        Token(type: .eof, lexeme: "", line: 1)]
    scan(source, expectedOutput)
}

@Test func ScanKeyword() {
    let source = "return 8"

    let expectedOutput = [
        Token(type: .return, lexeme: "return", line: 1),
        Token(type: .number, lexeme: "8", line: 1),
        Token(type: .eof, lexeme: "", line: 1)]
    scan(source, expectedOutput)
}
