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
    case markdown(text: String, single: Bool)
    case code(String)
    case unknown(String)
    
    func parse(line: String) -> Chunk {
        switch self {
        case .markdown(_, let single):
            return parseMarkdown(line: line, single: single)
        case .code(_):
            return parseCode(line: line)
        case .unknown(_):
            return parseUnknown(line: line)
        }
        
    }
    
    var line: String {
        switch self {
        case .markdown(let str, _):
            return str
        case .code(let str):
            return str
        case .unknown(let str):
            return str
        }
    }
    
}

func parseMarkdown(line: String, single: Bool) -> Chunk {
    
    guard !single else {
        return parseUnknown(line: line)
    }
    
    switch tokenize(line: line) {
    case .multilineEnd:
        return .unknown("")
    default:
        return .markdown(text: line, single: false)
    }
}

func parseUnknown(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineStart:
        return .markdown(text: "", single: false)
    case .single(let markdownLine):
        return .markdown(text: markdownLine, single: false)
    case .plain(let plainLine):
        return .code(plainLine)
    default:
        return .unknown(line)
    }
}

func parseCode(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineStart:
        return .markdown(text: "", single: false)
    case .single(let singleLine):
        return .markdown(text: singleLine, single: true)
    default:
        return .code(line)
    }
}

public func convertToMarkdown(from source: URL, to destination: URL) throws {
    let text = try String(contentsOf: source, encoding: .utf8)
    let markdown = convertToMarkdown(text: text)
    try markdown.write(to: destination, atomically: true, encoding: .utf8)
}


import PerfectMarkdown
import Splash


internal func convert(text: String, header: String = "", footer: String = "", conversion convert: (Chunk) -> String) -> String {
    let lines = text.components(separatedBy: .newlines)
    
    
    let html = lines
        .reduce((Chunk.unknown(""), header)) { (result, line) -> (Chunk, String) in
            let (currentChunk, result) = result
            let newChunk = currentChunk.parse(line: line)
            
            switch (currentChunk, newChunk) {
            case (.code(let oldText), .code(let newText)):
                return (.code("\(oldText)\n\(newText)"), result)
            case (.markdown(let oldText, _), .markdown(let newText, _)):
                return (.markdown(text: "\(oldText)\n\(newText.trimmingCharacters(in: .whitespaces))", single: false), result)
            case (.unknown(let oldText), .unknown(let newText)):
                return (.unknown("\(oldText)\n\(newText)"), result)
            default:
                let newStr = convert(currentChunk)
                return (newChunk, "\(result)\n\(newStr)")
            }
            
    }
    
    return html.1 + footer
}

public func convertToMarkdown(text: String) -> String {
    
    return convert(text: text) { chunk -> String in
        switch chunk {
        case .markdown(let text, _):
            return text
        case .code(let text):
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "" }
            return "\n```swift\n\(text)\n```\n"
        case .unknown(let text):
            return "\n\(text)"
        }
    }
}

import SwiftSoup

public func convertToHTML(text: String) throws -> String {
    let markdown = convertToMarkdown(text: text)
    let html = markdown.markdownToHTML ?? ""
    
    let doc = try parse(html)
    
    try doc.select("code").forEach {  element in
        let highlighter = SyntaxHighlighter(format: HTMLOutputFormat())
        let highlightedCode = highlighter.highlight(try element.text())
        try element.html(highlightedCode)
    }
    
    
    let head = """
    <style type="text/css" media="screen">
    pre {
        margin-bottom: 1.5em;
        background-color: #1a1a1a;
        padding: 16px 0;
        border-radius: 16px;
    }

    pre code {
        font-family: monospace;
        display: block;
        padding: 0 20px;
        color: #a9bcbc;
        line-height: 1.4em;
        font-size: 0.95em;
        overflow-x: auto;
        white-space: pre;
        -webkit-overflow-scrolling: touch;
    }

    pre code .keyword {
        color: #e73289;
    }

    pre code .type {
        color: #8281ca;
    }

    pre code .call {
        color: #348fe5;
    }

    pre code .property {
        color: #21ab9d;
    }

    pre code .number {
        color: #db6f57;
    }

    pre code .string {
        color: #fa641e;
    }

    pre code .comment {
        color: #6b8a94;
    }

    pre code .dotAccess {
        color: #92b300;
    }

    pre code .preprocessing {
        color: #b68a00;
    }
    </style>
    <!DOCTYPE html>
    <head>
        <title>A document with a short head</title>
    </head>
    """
    
    try doc.prepend(head)
    
    return try doc.html()
    
}

public func convertToHTML(from source: URL, to destination: URL) throws {
    let text = try String(contentsOf: source, encoding: .utf8)
    let markdown = try convertToHTML(text: text)
    try markdown.write(to: destination, atomically: true, encoding: .utf8)
}
