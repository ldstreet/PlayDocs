//
//  CommandContext+Extensions.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

// Convenience functions used for type safe accessing of a `Command's` arguments, options, and flags
extension CommandContext {
    
    /// Uses case of `CommandOptions` as a key to retrieve an option if it has been provided
    ///
    /// - Parameter key: CommandOptions case corresponding to desired option
    /// - Returns: The corresponding option if it has been provided by the user
    public subscript<Key: CommandOptions>(_ key: Key) -> String? {
        return option(key.caseName)
    }
    
    /// Uses case of `CommandMultipleOptions` as a key to retrieve an option's values if it has been provided
    ///
    /// - Parameter key: CommandMultipleOptions case corresponding to desired option
    /// - Returns: The corresponding array of option values if they have been provided by the user
    public subscript<Key: CommandMultipleOptions>(_ key: Key) -> [String] {
        return options(key.caseName)
    }
    
    /// Uses case of `CommandFlags` as a key to retrieve whether the flag has been provided
    ///
    /// - Parameter key: CommandFlags case corresponding to desired flag
    /// - Returns: `true` if flag has been provided, `false` if not
    public subscript<Key: CommandFlags>(_ key: Key) -> Bool {
        return flag(key.caseName)
    }
    
    /// Uses case of `CommandArguments` as a key to retrieve an argument
    ///
    /// - Parameter key: CommandArguments case corresponding to desired argument
    /// - Returns: The corresponding argument
    public func arg<Key: CommandArguments>(_ key: Key) throws -> String {
        return try argument(key.caseName)
    }
    
    /// Uses string key to retrieve an option if it has been provided
    ///
    /// - Parameter key: String corresponding to desired option
    /// - Returns: The corresponding option if it has been provided by the user
    private func option(_ key: String) -> String? {
        return options[key]
    }
    
    /// Uses string key to retrieve an array of options if they have been provided
    ///
    /// - Parameter key: String corresponding to desired option
    /// - Returns: The corresponding option values if they have been provided by the user
    private func options(_ key: String) -> [String] {
        guard let optionValue = option(key) else { return [] }
        return optionValue
            .split(separator: " ")
            .map(String.init)
    }
    
    /// String as a key to retrieve whether the flag has been provided
    ///
    /// - Parameter key: String corresponding to desired flag
    /// - Returns: `true` if flag has been provided, `false` if not
    private func flag(_ key: String) -> Bool {
        return options[key] != nil
    }
}
