//
//  Prompt.swift
//
//
//  Created by CheekyGhost Labs on 15/8/2023.
//

import Foundation
import ANSITerminal

/// Entry point into ``SiftPrompt`` utilities.
public enum Prompt {
    
    /// Will start a stylised prompt group with an introduction line. This is a good chance to surmise the
    /// prompts or work about to be completed.
    ///
    /// - Parameter title: The title to display to the user
    public static func startPromptGroup(title: String) {
        moveLineDown()
        write(ANSIChar.bracketOpen.standard)
        moveRight()
        write(" \(title) ".onCyan)
        moveLineDown()
        write(ANSIChar.bracketLine.standard)
    }

    /// Will close a stylised prompt group with an outro line. This is a good chance to surmise the
    /// outcome of the promp group.
    ///
    /// - Parameter title: The title to display to the user
    public static func endPromptGroup(title: String) {
        // Disable cursor
        cursorOff()
        // Move to new line
        moveDown()
        moveToColumn(0)
        // Draw a pipe and close bracket and move to end of line
        write(ANSIChar.bracketClose.standard)
        moveRight()
        // Write the title to display
        write(title)
        // Move to the end of the output
        moveLineDown()
        // Re-enable cursor
        cursorOn()
    }

    /// Will add a line to a stylised prompt group using a pipe and hyphen `●` with the given text.. This is a good chance to surmise any
    /// updates or progress etc.
    ///
    /// - Parameter title: The title to display to the user
    public static func writeGroupUpdate(title: String) {
        // Disable cursor
        cursorOff()
        // Move to new line
        moveDown()
        moveToColumn(0)
        // Draw a pipe and close bracket and move to end of line
        write(ANSIChar.circleFilled.standard)
        moveRight()
        // Write the title to display
        write(title)
        // Move to new line at beginning
        moveLineDown()
        moveToColumn(0)
        // Draw a pipe
        write(ANSIChar.bracketLine.standard)
        // Re-enable cursor
        cursorOn()
    }

    /// Will present a stylised prompt to the user to enter stnadard text input.
    ///
    /// You can validate the input using the `validator` property. This is currently required to reduce complexity, you can return ``ValidationResult/valid`` for any input to have no validation.
    /// - Parameters:
    ///   - question: The question to present to the user.
    ///   - placeholder: Optional placeholder text/hint to display to the user when no input is detected.
    ///   - isSecureEntry: Bool whether input characters should be masked.
    ///   - validationHandler: Closure invoked when input is submitted. Returns a ``ValidationResult``
    /// - Returns: `String`
    /// - SeeAlso: ``ValidationResult``
    public static func textInput(
        question: String,
        placeholder: String?,
        isSecureEntry: Bool,
        validator: @escaping (String) -> ValidationResult
    ) -> String {
        let prompt = InputPrompt(question: question, placeholder: placeholder, isSecureEntry: isSecureEntry, validationHandler: validator)
        return prompt.prompt()
    }
    
    /// Will present a stylised prompt to the user to select from a list of options using the up/down/enter keys.
    ///
    /// - Parameters:
    ///   - question: The question to present to the user.
    ///   - options: Array of options that have the same underlying type value.
    /// - Returns: The value `Type` of the selected option.
    public static func selectOption<Type>(
        question: String,
        options: [PromptOption<Type>]
    ) -> Type {
        precondition(options.count > 1, "There should be at least 2 options.")
        let prompt = OptionSetPrompt<Type>(question: question, options: options)
        return prompt.prompt()
    }
}
