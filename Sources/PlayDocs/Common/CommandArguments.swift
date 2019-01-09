//
//  CommandArguments.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

public protocol CommandArguments: CaseIterable {
    var argument: CommandArgument { get }
}

extension CommandArguments {
    public static var arguments: [CommandArgument] {
        return Self.allCases.map { $0.argument }
    }
}
