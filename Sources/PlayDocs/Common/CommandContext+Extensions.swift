//
//  CommandContext+Extensions.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

extension CommandContext {
    public func option<Key: CommandOptions>(_ key: Key) -> String? {
        return option(key.option.name)
    }
    
    public func flag<Key: CommandFlags>(_ key: Key) -> Bool {
        return flag(key.flag.name)
    }
    
    public func argument<Key: CommandArguments>(_ key: Key) throws -> String {
        return try argument(key.argument.name)
    }
    
    public func option(_ key: String) -> String? {
        return options[key]
    }
    
    public func flag(_ key: String) -> Bool {
        return options[key] != nil
    }
}
