//
//  CommandArguments.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command
import PlayDocsKit

/// Describes type that may be used as a `Command's` arguments - best modeled as an enum
public protocol CommandArguments: CaseIterable {
    var argument: CommandArgument { get }
}

extension CommandArguments {
    /// Exposes all arguments defined by conforming type
    public static var arguments: [CommandArgument] {
        return Self.allCases.map(get(\.argument))
    }
}
