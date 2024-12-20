import Foundation
import slox

@main
struct slox_cliMain {
    static func main() {
        guard CommandLine.arguments.count == 2 else {
            print("Usage: app file")
            exit(1)
        }

        let filePath = CommandLine.arguments[1]
        let contents = readFile(filePath: filePath)
        run(source: contents)
    }

    static func readFile(filePath: String) -> String {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            return fileContents
        } catch {
            print("Error reading file: \(error)")
            exit(2)
        }
    }
}
