//
//  PromptOption.swift
//
//
//  Created by Michael O'Brien on 16/8/2023.
//

import Foundation

/// Struct representing an option for a ``Prompt/selectOption(question:options:)`` invocation.
public struct PromptOption<Type> {

    // MARK: - Properties

    /// The display title for the option.
    let title: String

    /// The underlying value for the option
    let value: Type

    // MARK: - Lifecycle
    
    /// Will initialize a new option with the given properties.
    ///
    /// - Parameters:
    ///   - title: The title to display to the user.
    ///   - value: The underlying value to return when selected.
    public init(title: String, value: Type) {
        self.title = title
        self.value = value
    }
}
