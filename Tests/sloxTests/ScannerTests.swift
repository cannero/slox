import Testing
@testable import slox

@Test func ScanOpenBrace() {
    let source = "{"
    let expectedOutput = [
        Token(type: .leftBrace, lexeme: "{", line: 1),
        Token(type: .eof, lexeme: "", line: 1)]
    let scanner = Scanner(source)
    
    let res = scanner.scanTokens()

    #expect(res == expectedOutput)
}
