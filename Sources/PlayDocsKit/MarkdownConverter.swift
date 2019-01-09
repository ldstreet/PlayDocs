import Foundation

enum Token {
    case multilineStart
    case multilineEnd
    case single(line: String)
    case plain(line: String)
}

func tokenize(line: String) -> Token {
    if line
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .hasPrefix("/*:") {
        return Token.multilineStart
    } else if line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("*/") {
        return Token.multilineEnd
    } else if line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("//:") {
        return Token.single(line: line.replacingOccurrences(of: "//:", with: ""))
    } else {
        return Token.plain(line: line)
    }
}

enum Chunk {
    case markdown(String)
    case code(String)
    case unknown(String)
    
    func parse(line: String) -> Chunk {
        switch self {
        case .markdown(_):
            return parseMarkdown(line: line)
        case .code(_):
            return parseCode(line: line)
        case .unknown(_):
            return parseUnknown(line: line)
        }
        
    }
    
    var line: String {
        switch self {
        case .markdown(let str):
            return str
        case .code(let str):
            return str
        case .unknown(let str):
            return str
        }
    }
    
}

func parseMarkdown(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineEnd:
        return .unknown("")
    default:
        return .markdown(line)
    }
}

func parseUnknown(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineStart:
        return .markdown("")
    case .single(let _):
        return .markdown(line)
    case .plain(let plainLine):
        let codeStartLine = "```\n\(plainLine)"
        return .code(codeStartLine)
    default:
        return .unknown(line)
    }
}

func parseCode(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineStart:
        return .markdown("```\n")
    case .single(let singleLine):
        return .unknown("```\n\(singleLine)")
    default:
        return .code(line)
    }
}

func convertToMarkdown(text: String) -> String {
    let lines = text.split(separator: "\n")
    var res: (Chunk, String) =
        lines
            .map(String.init)
            .reduce((Chunk.unknown(""), "")) { (result, line) -> (Chunk, String) in
                let (previousChunk, result) = result
                let newChunk = previousChunk.parse(line: line)
                return (newChunk, "\(result)\n\(newChunk.line)")
    }
    if case Chunk.code(_) = res.0 {
        res.1 += "\n```"
    }
    return res.1
}

guard CommandLine.arguments.count == 2 else {
    print("Please provide path to playground as argument")
    exit(1)
}

let path = CommandLine.arguments[1]
let url = URL.init(fileURLWithPath: path)
let text = try String(contentsOf: url, encoding: .utf8)
print(convertToMarkdown(text: text))

