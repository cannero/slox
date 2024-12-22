// Autogenerated by generateAst.fsx

protocol ExprVisitor {
    associatedtype ExprVisitorReturn
    func visitBinaryExpr(_ expr: Binary) -> ExprVisitorReturn
    func visitGroupingExpr(_ expr: Grouping) -> ExprVisitorReturn
    func visitLiteralExpr(_ expr: Literal) -> ExprVisitorReturn
    func visitUnaryExpr(_ expr: Unary) -> ExprVisitorReturn
}

protocol Expr {
   func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn
}

extension Expr {
}

class Binary: Expr {
    let left: Expr
    let op: Token
    let right: Expr

    init(left: Expr, op: Token, right: Expr) {
        self.left = left
        self.op = op
        self.right = right
    }

    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn {
        visitor.visitBinaryExpr(self)
    }
}

class Grouping: Expr {
    let expression: Expr

    init(expression: Expr) {
        self.expression = expression
    }

    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn {
        visitor.visitGroupingExpr(self)
    }
}

class Literal: Expr {
    let value: Any?

    init(value: Any?) {
        self.value = value
    }

    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn {
        visitor.visitLiteralExpr(self)
    }
}

class Unary: Expr {
    let op: Token
    let right: Expr

    init(op: Token, right: Expr) {
        self.op = op
        self.right = right
    }

    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn {
        visitor.visitUnaryExpr(self)
    }
}

