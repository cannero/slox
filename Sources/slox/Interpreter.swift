class Interpreter {
    private var environment = Environment()
    
    func interpret(statements: [Stmt]) throws {
        do {
            for statement in statements {
                try execute(statement)
            }
        } catch let error as RuntimeError {
            runtimeError(error: error)
        }
    }

    func evaluate(_ expr: Expr) throws -> ResultValue {
        try expr.accept(visitor: self)
    }
}

extension Interpreter : ExprVisitor {
    func visitAssignExpr(_ expr: Assign) throws -> ResultValue {
        let value = try evaluate(expr.value)
        try environment.assign(name: expr.name, value: value)
        return value;
    }

    func visitBinaryExpr(_ expr: Binary) throws -> ResultValue {
        let left = try evaluate(expr.left)
        let right = try evaluate(expr.right)

        switch (expr.op.type) {
        case .greater: fallthrough
        case .greaterEqual: fallthrough
        case .less: fallthrough
        case .lessEqual:
            guard case let .int(leftValue) = left, case let .int(rightValue) = right else {
                throw RuntimeError.notANumber(expr.op)
            }

            let comparisonOperation = try opToComparison(expr.op)
            return .bool(comparisonOperation(leftValue, rightValue))
        case .equalEqual:
            return .bool(left == right)
        case .bangEqual:
            return .bool(left != right)
        case .slash: fallthrough
        case .star: fallthrough
        case .minus:
            guard case let .int(leftValue) = left, case let .int(rightValue) = right else {
                throw RuntimeError.notANumber(expr.op)
            }

            let arithmeticOperation = try opToArithmetic(expr.op)
            return .int(arithmeticOperation(leftValue, rightValue))
        case .plus:
            if case let .int(leftValue) = left, case let .int(rightValue) = right {
                return .int(leftValue + rightValue)
            }

            if case let .string(leftValue) = left, case let .string(rightValue) = right {
                return .string(leftValue + rightValue)
            }

            throw RuntimeError(expr.op, "Operands must be two numbers or two strings.")
        default:
            throw RuntimeError(expr.op, "Unknown binary operator")
        }
    }
   
    func visitGroupingExpr(_ expr: Grouping) throws -> ResultValue {
        try evaluate(expr.expression)
    }

    func visitLiteralExpr(_ expr: Literal) throws -> ResultValue {
        try ResultValue.fromLiteralValue(expr.value)
    }

    func visitUnaryExpr(_ expr: Unary) throws -> ResultValue {
        let right = try evaluate(expr.right)

        switch expr.op.type {
        case .bang:
            return .bool(!isTruthy(right))
        case .minus:
            guard case let .int(intValue) = right else {
                throw RuntimeError.notANumber(expr.op)
            }

            return .int(-intValue)
        default:
            throw RuntimeError(expr.op, "Invalid unary operation")
        }
    }

    func visitVariableExpr(_ expr: Variable) throws -> ResultValue {
        return try environment.get(name: expr.name)
    }

    private func isTruthy(_ object: ResultValue) -> Bool {
        switch object {
        case let .bool(bool): bool
        case .nil: false
        default: true
        }
    }

    private func opToArithmetic(_ op: Token) throws -> (Int, Int) -> Int {
        switch op.type {
        case .minus: (-)
        case .slash: (/)
        case .star: (*)
        case .plus: (+)
        default:
            throw RuntimeError(op, "unknown arithmetic operation")
        }
    }

    private func opToComparison(_ op: Token) throws -> (Int, Int) -> Bool {
        switch op.type {
        case .greater: (>)
        case .greaterEqual: (>=)
        case .less: (<)
        case .lessEqual: (<=)
        default:
            throw RuntimeError(op, "unknown comparison operation")
        }
    }
}

extension Interpreter : StmtVisitor {
    func visitBlockStmt(_ stmt: Block) throws -> Void {
        try executeBlock(stmt.statements, Environment(enclosing: environment))
    }

    func visitExpressionStmt(_ stmt: Expression) throws -> Void {
        _ = try evaluate(stmt.expression)
    }

    func visitPrintStmt(_ stmt: Print) throws -> Void {
        let value = try evaluate(stmt.expression);
        print(value);
    }

    func visitVarStmt(_ stmt: Var) throws -> Void {
        var value: ResultValue? = nil;
        if let initializer = stmt.initializer {
            value = try evaluate(initializer)
        }

        environment.define(name: stmt.name.lexeme, value: value)
    }

    private func execute(_ stmt: Stmt) throws {
        try stmt.accept(visitor: self)
    }

    private func executeBlock(_ statements: [Stmt], _ environment: Environment) throws {
        let previous = self.environment
        defer {
            self.environment = previous
        }

        self.environment = environment

        for statement in statements {
            try execute(statement)
        }
    }
}
