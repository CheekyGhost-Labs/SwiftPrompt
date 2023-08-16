//
//  OptionSetState.swift
//
//
//  Created by Michael O'Brien on 16/8/2023.
//

import Foundation

class OptionSetState<Type> {

    // MARK: - Properties

    /// The array of options presented to the user.
    let options: [OptionSetPrompt<Type>.Item]

    /// The range of lines the options appear on.
    let rangeOfLines: (min: Int, max: Int)

    /// The currently active/focused line index.
    var activeIndex: Int = .zero
    
    /// Will return the currently active/selected option.
    var selectedOption: OptionSetPrompt<Type>.Item? {
        return options.first(where: { $0.line == activeIndex })
    }

    // MARK: - Lifecycle

    init(options: [OptionSetPrompt<Type>.Item], activeIndex: Int, rangeOfLines: (min: Int, max: Int)) {
        self.activeIndex = activeIndex
        self.rangeOfLines = rangeOfLines
        self.options = options
    }

    func optionAtLine(_ line: Int) -> OptionSetPrompt<Type>.Item? {
        options.first(where: { $0.line == line })
    }
}
