//
//  CommandProtocol.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

public protocol CommandProtocol: Command {
    associatedtype Options: CommandOptions
    associatedtype Arguments: CommandArguments
    associatedtype Flags: CommandFlags
}

extension CommandProtocol {
    
    public var arguments: [CommandArgument] {
        return Arguments.arguments
    }
    
    public var options: [CommandOption] {
        return Options.options + Flags.flags
    }
}


