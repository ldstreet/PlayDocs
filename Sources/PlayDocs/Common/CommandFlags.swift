//
//  CommandFlags.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command
import PlayDocsKit

/// Describes type that may be used as a `Command's` options - best modeled as an enum
public protocol CommandFlags: CaseIterable {
    var flag: CommandOption { get }
}

extension CommandFlags {
    /// Exposes all flags defined by conforming type
    public static var flags: [CommandOption] {
        return Self.allCases.map(get(\.flag))
    }
}
