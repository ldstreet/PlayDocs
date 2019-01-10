//
//  String+Extensions.swift
//  Async
//
//  Created by Luke Street on 1/10/19.
//

import Foundation

extension String {
    /// Appends the given String with a newline but only if both strings are non-empty
    ///
    /// - Parameter text: String to append
    /// - Returns: Combined string
    internal func appendWithNewlineIfNotEmpty(_ text: String) -> String {
        guard !text.isEmpty else { return self }
        guard !self.isEmpty else { return text }
        return "\(self)\n\(text)"
    }
}
