//
//  CommandOptions.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command
import PlayDocsKit

/// Describes type that may be used as a `Command's` options - best modeled as an enum
public protocol CommandOptions: CaseIterable {
    var option: CommandOption { get }
}

extension CommandOptions {
    /// Exposes all options defined by conforming type
    public static var options: [CommandOption] {
        return Self.allCases.map(get(\.option))
    }
}
