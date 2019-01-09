//
//  CommandFlags.swift
//  Async
//
//  Created by Luke Street on 12/30/18.
//

import Command

public protocol CommandFlags: CaseIterable {
    var flag: CommandOption { get }
}

extension CommandFlags {
    public static var flags: [CommandOption] {
        return Self.allCases.map { $0.flag }
    }
}
