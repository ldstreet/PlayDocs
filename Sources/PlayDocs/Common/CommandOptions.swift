//
//  CommandOptions.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

public protocol CommandOptions: CaseIterable {
    var option: CommandOption { get }
}

extension CommandOptions {
    public static var options: [CommandOption] {
        return Self.allCases.map { $0.option }
    }
}
