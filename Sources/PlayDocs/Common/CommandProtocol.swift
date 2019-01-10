//
//  CommandProtocol.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

/// Allows a Command to define its options, arguments, and flags by simply supplying the desired types
public protocol CommandProtocol: Command {
    associatedtype Options: CommandOptions
    associatedtype Arguments: CommandArguments
    associatedtype Flags: CommandFlags
}

extension CommandProtocol {
    
    /// Satisfy `arguments` requirement using associated `CommandArguments` type
    public var arguments: [CommandArgument] {
        return Arguments.arguments
    }
    
    /// Satisfy `options` requirement using associated `CommandOptions` and `CommandFlags` type
    public var options: [CommandOption] {
        return Options.options + Flags.flags
    }
}


