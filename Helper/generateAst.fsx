open System
open System.IO

[<Literal>]
let BasePath = "../Sources/slox"

let TypesExpr = ["Binary   : Expr left, Token op, Expr right";
                 "Grouping : Expr expression";
                 "Literal  : LiteralValue? value";
                 "Unary    : Token op, Expr right"]

let splitType (typestring: string) =
    let parts = typestring.Split(':')
    parts[0].Trim(), parts[1].Trim()

let splitIntoFieldTypeAndName (fields: string) =
    fields.Split(',')
    |> Array.map (fun x ->
                  let xs = x.Trim().Split(' ')
                  xs[0], xs[1])

let addVisitFunction (writer: TextWriter) baseName (className, _) =
    writer.Write($$"""    func visit{{className}}{{baseName}}(_ expr: {{className}}) """)
    writer.WriteLine($$"""throws -> {{baseName}}VisitorReturn""")

let defineVisitor (writer: TextWriter) baseName types =
    writer.WriteLine($$"""protocol {{baseName}}Visitor {""")
    writer.WriteLine($$"""    associatedtype {{baseName}}VisitorReturn""")

    let addVisitFunctionWithWriter = addVisitFunction writer baseName
    types
    |> List.map splitType
    |> List.iter addVisitFunctionWithWriter
    
    writer.WriteLine("}")
    writer.WriteLine("")

let defineType (writer: TextWriter) baseName (className, (fields: string)) =
    writer.WriteLine($$"""class {{className}} : {{baseName}} {""")

    let typeAndName = splitIntoFieldTypeAndName fields
    for t, n in typeAndName do
        writer.WriteLine($$"""    let {{n}}: {{t}}""")
    writer.WriteLine("")

    writer.Write("    init(")
    let initVariables =
        typeAndName
        |> Array.map (fun (t, n) -> $$"""{{n}}: {{t}}""")
        |> String.concat ", "
    writer.Write(initVariables)
    writer.WriteLine(") {")
    for t, n in typeAndName do
        writer.WriteLine($$"""        self.{{n}} = {{n}}""")
    writer.WriteLine("    }")
    writer.WriteLine("")

    writer.WriteLine($$"""    override func accept<V: {{baseName}}Visitor, R>(visitor: V) throws -> R where R == V.{{baseName}}VisitorReturn {""")
    writer.WriteLine($$"""        try visitor.visit{{className}}{{baseName}}(self)""")
    writer.WriteLine("    }")
    writer.WriteLine("")

    writer.WriteLine($$"""    override func isEqualTo (_ other: {{baseName}}) -> Bool {""")
    writer.WriteLine($$"""        guard let other = other as? {{className}} else {return false}""")
    let comparison =
        typeAndName
        |> Array.map snd
        |> Array.map (fun n -> $$"""{{n}} == other.{{n}}""")
        |> String.concat $$""" &&{{Environment.NewLine}}               """
    writer.WriteLine($$"""        return {{comparison}}""")
    writer.WriteLine($$"""    }""")

    writer.WriteLine("}")
    writer.WriteLine("")

let defineAst baseName types =
    use writer = new StreamWriter(Path.Combine(BasePath, baseName + ".swift"))
    writer.WriteLine($$"""// Autogenerated by {{__SOURCE_FILE__}}""")
    writer.WriteLine("")
    writer.WriteLine("import Foundation")
    writer.WriteLine("")

    defineVisitor writer baseName types

    // must be a base class, implement Equatable does not work with protocol
    writer.WriteLine($$"""class {{baseName}} : Equatable {""")
    writer.WriteLine($$"""   func accept<V: {{baseName}}Visitor, R>(visitor: V) throws -> R where R == V.{{baseName}}VisitorReturn {""")
    writer.WriteLine("        preconditionFailure(\"base class cannot be used directly\")")
    writer.WriteLine("    }")
    writer.WriteLine("")
    writer.WriteLine($$"""    static func == (lhs: {{baseName}}, rhs: {{baseName}}) -> Bool {""")
    writer.WriteLine($$"""        lhs.isEqualTo(rhs)""")
    writer.WriteLine($$"""    }""")
    writer.WriteLine("")
    writer.WriteLine($$"""    func isEqualTo (_ other: {{baseName}}) -> Bool {""")
    writer.WriteLine("        preconditionFailure(\"base class cannot be used directly\")")
    writer.WriteLine($$"""    }""")
    writer.WriteLine("}")
    writer.WriteLine("")
    let defineTypeWithWriter = defineType writer baseName
    types
    |> List.map splitType
    //|> List.iter (printfn "%A")
    //|> List.iter2 (fun x y -> printfn "%A, %A" x y)
    |> List.iter defineTypeWithWriter


defineAst "Expr" TypesExpr
