//
//  PromptUtils.swift
//  
//
//  Created by Michael O'Brien on 16/8/2023.
//

import ANSITerminal
import Foundation

enum PromptUtils {
    
    /// Will update the first character of the first line (the prompt line) to a green check mark, then iterate through each remaining line and revert the color of the first character to standard.
    /// - Parameters:
    ///   - startLine: The line/row to start changing at.
    ///   - endLine: The line/row to end changes at.
    ///   - prompt: The prompt/question presented to the user.
    static func updateStylesForInputCompletion(startLine: Int, endLine: Int, prompt: String) {
        // Disable cursor
        cursorOff()

        // Update content to completed state
        (startLine...endLine).forEach {
            if $0 == startLine {
                writeAt(row: $0, col: 0, text: "\(ANSIChar.checkmark.success) \(prompt)")
            } else {
                writeAt(row: $0, col: 0, text: ANSIChar.bracketLine.standard)
            }
        }
        // Move to the last line
        moveTo(endLine, 0)

        // Re-enable the cursor
        cursorOn()
    }
    
    /// Will write the given text at the given row and column position.
    /// - Parameters:
    ///   - row: The line to write on.
    ///   - col: The column offset to start writing at.
    ///   - text: The text to write.
    static func writeAt(row: Int, col: Int, text: String) {
        moveTo(row, col)
        write(text)
    }
    
    /// Will update the first character in the given line range to the given text. The text will be closed off with the close bracket text.
    ///
    /// - Parameters:
    ///   - fromLine: The line/row to start changing at.
    ///   - toLine: The line/row to end changes at.
    ///   - text: The text to replace/update to.
    ///   - closeChar: The char to write at the beginning of the last line. Defaults to a bracket close char in active color.
    static func updateFirstCharColor(fromLine: Int, toLine: Int, withText text: String, closeChar: String = ANSIChar.bracketClose.active) {
        (fromLine + 1...toLine - 1).forEach { writeAt(row: $0, col: 0, text: text) }
        writeAt(row: toLine, col: 0, text: closeChar)
    }
}
