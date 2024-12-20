public func run(source: String) {
    let scanner = Scanner(source)
    let tokens = scanner.scanTokens()

    for token in tokens {
        print(token)
    }
}

func error(_ line: Int, _ message: String) {
    report(line, "", message)
}

func report(_ line: Int, _ location: String, _ message: String) {
    print("[line \(line)]: Error\(location): \(message)")
}
