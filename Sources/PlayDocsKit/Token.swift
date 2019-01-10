//
//  Token.swift
//  Async
//
//  Created by Luke Street on 1/9/19.
//

/// Describes the different tokens found in the lines of a Swift file with comments containing markdown
///
/// - multilineStart: the start of multiple lines of markdown
/// - multilineEnd: the end of multiple lines of markdown
/// - single: a single line of markdown
/// - plain: a normal line of swift source code
internal enum Token {
    case multilineStart
    case multilineEnd
    case single(line: String)
    case plain(line: String)
}

/// Takes in a line of Swift source code and returns the assigned token for that line
///
/// - Parameter line: A line of Swift source code
/// - Returns: The `Token` corresponding to that line
internal func tokenize(line: SwiftSource) -> Token {
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
