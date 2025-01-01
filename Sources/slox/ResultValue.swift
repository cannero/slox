enum ResultValue : Equatable
{
    case int(Int)
    case string(String)
    case bool(Bool)
    case `nil`

    static func fromLiteralValue(_ literal: LiteralValue?) throws -> Self {
        switch literal {
        case let .int(int): .int(int)
        case let .string(string): .string(string)
        case let .bool(bool): .bool(bool)
        case .nil: .nil
        case nil:
        throw RuntimeError("nil literal value")
        }
    }
}
