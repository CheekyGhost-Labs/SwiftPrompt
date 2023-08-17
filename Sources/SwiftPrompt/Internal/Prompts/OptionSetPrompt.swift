//
//  OptionsPrompt.swift
//  
//
//  Created by CheekyGhost Labs on 16/8/2023.
//

import ANSITerminal

class OptionSetPrompt<Type> {

    // MARK: - Supplementary

    struct Item {

        /// The display title for the item
        let title: String

        /// The underlying value for the ite
        let value: Type

        /// The line the option appears on
        let line: Int

        init(title: String, value: Type, line: Int) {
            self.title = title
            self.value = value
            self.line = line
        }
    }

    // MARK: - Properties
    
    /// The question to display to the user.
    let question: String
    
    /// Array of option items the user an select from.
    let options: [PromptOption<Type>]

    // MARK: - Lifecycle

    init(question: String, options: [PromptOption<Type>]) {
        self.question = question
        self.options = options
    }

    // MARK: - Helpers

    func prompt() -> Type {
        // Disable cursor
        cursorOff()

        // Move to next line
        moveLineDown()

        // Write prompt with icon prefix
        write(ANSIChar.circleFilled.active)
        moveRight()
        write(question)

        // Get current line and bump to next line
        let currentLine = readCursorPos().row + 1

        // Mutate options to account for line
        var optionItems: [Item] = []
        for (index, option) in options.enumerated() {
            let item = Item(title: option.title, value: option.value, line: currentLine + index)
            optionItems.append(item)
        }
        // Create options state
        let state = OptionSetState(options: optionItems, activeIndex: currentLine, rangeOfLines: (currentLine, currentLine + options.count - 1))

        // Wrie out each option
        options.forEach { option in
            moveLineDown()
            let isActive = readCursorPos().row == state.activeIndex
            // Draw active brackt line on left
            write(ANSIChar.bracketLine.active)
            // Move to right of line
            moveRight()
            // Draw a filled or empty circle based on current focus
            if isActive {
                write(ANSIChar.circleFilled.rawValue.lightGreen)
            } else {
                write(ANSIChar.circleOutline.standard)
            }
            // Move to right of prefix character
            moveRight()

            // Write out option title
            if isActive {
                write(option.title)
            } else {
                write(option.title.lightWhite)
            }
        }

        // Move to last line
        moveLineDown()
        // Draw closing bracket
        let bottomPosition = readCursorPos()
        write(ANSIChar.bracketClose.active)

        while true {
            clearBuffer()
            guard keyPressed() else { continue }
            let keyChar = readChar()

            if keyChar == NonPrintableChar.enter.char() {
                break
            }

            let pressedKey = readKey()
            switch pressedKey.code {
            case .up:
                if state.activeIndex > state.rangeOfLines.min {
                    state.activeIndex -= 1
                    reRender(state: state)
                }
            case .down:
                if state.activeIndex < state.rangeOfLines.max {
                    state.activeIndex += 1
                    reRender(state: state)
                }
            default:
                break
            }
        }

        // Cleanup and write trailing output
        PromptUtils.updateStylesForInputCompletion(startLine: currentLine - 1, endLine: bottomPosition.row, prompt: question)

        // Return selected option value
        return state.selectedOption!.value
    }

    private func reRender(state: OptionSetState<Type>) {
        (state.rangeOfLines.min...state.rangeOfLines.max).forEach { line in
            let isActive = line == state.activeIndex
            // Update option prefix indicator
            let stateIndicator = isActive ? ANSIChar.circleFilled.rawValue.lightGreen : ANSIChar.circleOutline.standard
            PromptUtils.writeAt(row: line, col: 3, text: stateIndicator)

            // Update option title
            if let option = state.optionAtLine(line) {
                let title = isActive ? option.title.cyan : option.title
                PromptUtils.writeAt(row: line, col: 5, text: title)
            }
        }
    }
}
