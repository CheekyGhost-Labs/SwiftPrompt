//
//  InputPrompt.swift
//
//
//  Created by CheekyGhost Labs on 16/8/2023.
//

import ANSITerminal
import Foundation

class InputPrompt {

    // MARK: - Properties

    let question: String

    let placeholder: String

    let isSecureEntry: Bool

    let validationHandler: (String) -> ValidationResult

    // MARK: - Lifecycle

    init(
        question: String,
        placeholder: String?,
        isSecureEntry: Bool,
        validationHandler: @escaping (String) -> ValidationResult
    ) {
        self.question = question
        self.placeholder = placeholder ?? ""
        self.isSecureEntry = isSecureEntry
        self.validationHandler = validationHandler
    }

    // MARK: - Helpers: Private

    func prompt() -> String {
        // Enable cursor
        cursorOn()
        moveLineDown()
        let startLine = readCursorPos().row

        // Write prompt with bracket open
        let promptOpening = "\(ANSIChar.circleFilled.active) \(question.cyan)"
        write(promptOpening)

        // Setup input area
        moveLineDown()
        write(ANSIChar.bracketLine.active)
        moveLineDown()
        write(ANSIChar.bracketClose.active)

        // Get other positions
        let bottomPosition = readCursorPos()
        // Move up to input area (above closing bracket)
        moveLineUp()
        moveRight(2)

        // Get initial cursor position
        let initialPosition = readCursorPos()

        // Write placeholder (if exists) - move to beginning of line
        write(placeholder.lightWhite)
        moveTo(initialPosition.row, initialPosition.col)

        // Transient validation state
        var validationFailed = false

        // Listen for input
        let input = readInput(
            validator: validationHandler,
            validationFailureHandler: { failureMessage in
                validationFailed = true
                // Disable cursor
                cursorOff()

                // Get current position
                let currentPosition = readCursorPos()
                // Write warning at start of line
                PromptUtils.writeAt(row: startLine + 1, col: 0, text: ANSIChar.warningSymbol.warning)

                // Update bracket color to warning colored
                PromptUtils.updateFirstCharColor(fromLine: startLine, toLine: bottomPosition.row, withText: ANSIChar.circleFilled.warning)

                // Write the failure message and move to end of line
                PromptUtils.writeAt(row: bottomPosition.row, col: bottomPosition.col + 1, text: failureMessage.yellow)
                moveTo(currentPosition.row, currentPosition.col)

                // Re-enable cursor
                cursorOn()
            },
            onCharacterInput: { char in
                // If previous submission was invalid
                if validationFailed {
                    // Disable cursor
                    cursorOff()

                    // Get current position
                    let currentPosition = readCursorPos()
                    // Replace bracket with active line
                    PromptUtils.writeAt(row: startLine, col: 0, text: ANSIChar.circleFilled.active)
                    PromptUtils.updateFirstCharColor(fromLine: startLine, toLine: bottomPosition.row, withText: ANSIChar.bracketLine.active)
                    // Move to the start of the input line
                    moveTo(bottomPosition.row, bottomPosition.col + 1)
                    // Clear invalid input
                    clearToEndOfLine()
                    // Move back to current position
                    moveTo(currentPosition.row, currentPosition.col)
                    // Re-enable cursor
                    cursorOn()
                    // Reset validation state
                    validationFailed = false
                }
                // Write the new character
                if isSecureEntry {
                    write(ANSIChar.diamondFilled.noColour)
                } else {
                    write("\(char)")
                }
            },
            onDelete: { row, col in
                moveTo(row, col)
                deleteChar()
            },
            removePlaceholder: {
                moveTo(initialPosition.row, initialPosition.col)
                clearToEndOfLine()
            },
            showPlaceholder: {
                write(placeholder.lightWhite)
                moveTo(initialPosition.row, initialPosition.col)
            }
        )

        PromptUtils.updateStylesForInputCompletion(startLine: startLine, endLine: bottomPosition.row, prompt: question)
        return input
    }

    private func readInput(
        validator: (String) -> ValidationResult,
        validationFailureHandler: (String) -> Void,
        onCharacterInput: (Character) -> Void,
        onDelete: (Int, Int) -> Void,
        removePlaceholder: () -> Void,
        showPlaceholder: () -> Void
    ) -> String {
        var output = ""

        while true {
            clearBuffer()
            guard keyPressed() else { continue }
            let keyChar = readChar()

            // If pressed enter
            if keyChar == NonPrintableChar.enter.char() {
                let result = validator(output)
                if case let ValidationResult.invalid(message) = result {
                    validationFailureHandler(message)
                } else {
                    break
                }
            } else if keyChar == NonPrintableChar.del.char() {
                let cursorPosition = readCursorPos()
                guard !output.isEmpty else {
                    showPlaceholder()
                    continue
                }
                onDelete(cursorPosition.row, cursorPosition.col - 1)
                _ = output.removeLast()
                if output.isEmpty {
                    showPlaceholder()
                }
            } else if !isNonPrintable(char: keyChar) {
                if output.isEmpty { removePlaceholder() }
                onCharacterInput(keyChar)
                output.append(keyChar)
            }
        }
        return output
    }
}
