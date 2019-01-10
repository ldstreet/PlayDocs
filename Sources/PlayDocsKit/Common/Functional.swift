//
//  Functional.swift
//  Async
//
//  Created by Luke Street on 1/9/19.
//

import Foundation

/// Uses a property of a type's `KeyPath` to produce a function which takes an instance of the root type and returns the specified property
///
/// - Parameter keyPath: The `KeyPath` leading to desired property
/// - Returns: A function that takes in an instance of a type and returns the property found at the specified `KeyPath`
public func get<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: keyPath]
    }
}
