import Foundation
import SwiftSoup


// Typealiases for code clarity
public typealias SwiftSource = String
public typealias MarkdownSource = String
public typealias HTMLSource = String

/// Allows a custom conversion via the conversion closure which exposes found `Chunks` and allows them to be transformed into a converted string
///
/// - Parameters:
///   - source: String to be converted
///   - header: String to be prepended to output
///   - footer: String to be appended to output
///   - convert: Function which performs a conversion given a `Chunk`
/// - Returns: Converted String
public func convert(source: SwiftSource, prepending header: String = "", appending footer: String = "", conversion convert: (Chunk) -> String) -> String {
    
    let lines = source.components(separatedBy: .newlines)
    
    let (lastChunk, html) = lines
        .reduce((Chunk.unknown(text: ""), header)) { (result, line) -> (Chunk, String) in
            let (currentChunk, result) = result
            let newChunk = currentChunk.parse(nextLine: line)
            
            switch (currentChunk, newChunk) {
            case (.code(let oldText), .code(let newText)):
                return (.code(text: "\(oldText)\n\(newText)"), result)
            case (.markdown(let oldText, _, let start), .markdown(let newText, _, _)):
                if start {
                    return (.markdown(text: oldText.appendWithNewlineIfNotEmpty(newText.trimmingCharacters(in: .whitespaces)), single: false, start: false), result)
                } else {
                    return (.markdown(text: "\(oldText)\n\(newText.trimmingCharacters(in: .whitespaces))", single: false, start: false), result)
                }
                
            case (.unknown(let oldText), .unknown(let newText)):
                return (.unknown(text: "\(oldText)\n\(newText)"), result)
            default:
                let newStr = convert(currentChunk)
                let newResult = result.appendWithNewlineIfNotEmpty(newStr)
                return (newChunk, newResult)
            }
            
    }
    return html
        .appendWithNewlineIfNotEmpty(convert(lastChunk))
        .appendWithNewlineIfNotEmpty(footer)
}

extension String {
    func appendWithNewlineIfNotEmpty(_ text: String) -> String {
        guard !text.isEmpty else { return self }
        guard !self.isEmpty else { return text }
        return "\(self)\n\(text)"
    }
}

/// Converts Swift Source code into Markdown
///
/// - Parameter source: String of Swift source code
/// - Returns: String of valid markdown
public func convertToMarkdown(from source: SwiftSource) -> MarkdownSource {
    
    return convert(source: source) { chunk -> String in
        switch chunk {
        case .markdown(let text, _, _):
            return text
        case .code(let text):
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "" }
            return "```swift\n\(text)\n```"
        case .unknown(let text):
            return text
        }
    }
}

/// Converts a swift source file to markdown and saves it to destinatoin
///
/// - Parameters:
///   - source: URL pointing to Swift Source file
///   - destination: URL pointing to intended destination for Markdown
/// - Throws: Throws any errors that may occur during read and write operations
public func convertToMarkdown(from source: URL, to destination: URL) throws {
    let text = try String(contentsOf: source, encoding: .utf8)
    let markdown = convertToMarkdown(from: text)
    try markdown.write(to: destination, atomically: true, encoding: .utf8)
}

/// Converts Swift Source code into HTML
///
/// - Parameter source: String of Swift source code
/// - Returns: String of valid html including CSS
public func convertToHTML(from source: SwiftSource) throws -> HTMLSource {
    let markdown = convertToMarkdown(from: source)
    let html = Current.convertToHTML(markdown) ?? ""
    
    let doc = try parse(html)
    
    try doc.select("code").forEach {  element in
        let highlightedCode = Current.convertToHighlightedHTML(try element.text())
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
    """
    
    try doc.prepend(head)
    
    return try doc.html()
    
}

/// Converts a swift source file to html and saves it to destinatoin
///
/// - Parameters:
///   - source: URL pointing to Swift Source file
///   - destination: URL pointing to intended destination for HTML
/// - Throws: Throws any errors that may occur during read and write operations
public func convertToHTML(from source: URL, to destination: URL) throws {
    let text = try String(contentsOf: source, encoding: .utf8)
    let markdown = try convertToHTML(from: text)
    try markdown.write(to: destination, atomically: true, encoding: .utf8)
}
