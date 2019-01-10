//
//  Chunk.swift
//  Async
//
//  Created by Luke Street on 1/9/19.
//

/// Describes a chunk of the Swift source code and the text within that chunk
///
/// - markdown: A chunk of markdown source
/// - code: A chunk of source code
/// - unknown: A chunk of undefined source. (Not sure if this case is necessary. Perhaps it can be removed in the future?)
public enum Chunk {
    case markdown(text: String, single: Bool)
    case code(text: String)
    case unknown(text: String)
    
    /// Given the knowledge of the previous chunk, parse the next line with limited cases
    ///
    /// - Parameter line: the line to be parsed
    /// - Returns: The `Chunk` representing the next line of code
    internal func parse(nextLine line: String) -> Chunk {
        switch self {
        case .markdown(_, let single):
            return parseMarkdown(line: line, single: single)
        case .code(_):
            return parseCode(line: line)
        case .unknown(_):
            return parseUnknown(line: line)
        }
        
    }
    
    /// returns the text contained within the chunk
    var text: String {
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

/// Assumes that the previous line was markdown in order to parse the next line
///
/// - Parameters:
///   - line: The line needed to be parsed
///   - single: Whether or not the previous markdown line was just a single line of markdown ("//:")
/// - Returns: The `Chunk` corresponding to the provided line
internal func parseMarkdown(line: String, single: Bool) -> Chunk {
    
    guard !single else {
        return parseUnknown(line: line)
    }
    
    switch tokenize(line: line) {
    case .multilineEnd:
        return .unknown(text: "")
    default:
        return .markdown(text: line, single: false)
    }
}

/// Assumes that the previous line was unknown in order to parse the next line
///
/// - Parameters:
///   - line: The line needed to be parsed
/// - Returns: The `Chunk` corresponding to the provided line
internal func parseUnknown(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineStart:
        return .markdown(text: "", single: false)
    case .single(let markdownLine):
        return .markdown(text: markdownLine, single: false)
    case .plain(let plainLine):
        return .code(text: plainLine)
    default:
        return .unknown(text: line)
    }
}

/// Assumes that the previous line was code in order to parse the next line
///
/// - Parameters:
///   - line: The line needed to be parsed
/// - Returns: The `Chunk` corresponding to the provided line
internal func parseCode(line: String) -> Chunk {
    switch tokenize(line: line) {
    case .multilineStart:
        return .markdown(text: "", single: false)
    case .single(let singleLine):
        return .markdown(text: singleLine, single: true)
    default:
        return .code(text: line)
    }
}
