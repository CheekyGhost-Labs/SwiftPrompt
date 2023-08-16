//
//  ANSIChar.swift
//  
//
//  Created by CheekyGhost Labs on 16/8/2023.
//

import Foundation
import Rainbow

/// Enumeration of common ANSI characters used in the library.
///
/// These are mainly to avoid hard-coded repeated strings, have added some computed properties for grabbing color variants via Rainbow.
enum ANSIChar: CaseIterable {
    case bracketOpen
    case bracketLine
    case bracketClose
    case warningSymbol
    case circleFilled
    case circleOutline
    case diamondFilled
    case checkmark
    case hyphen

    // MARK: - Convenience

    var rawValue: String {
        switch self {
        case .bracketOpen:
            "┌"
        case .bracketLine:
            "│"
        case .bracketClose:
            "└"
        case .warningSymbol:
            "▲"
        case .circleFilled:
            "●"
        case .circleOutline:
            "○"
        case .diamondFilled:
            "◆"
        case .checkmark:
            "√"
        case .hyphen:
            "-"
        }
    }

    var noColour: String {
        rawValue
    }

    var standard: String {
        rawValue.lightWhite
    }

    var active: String {
        rawValue.lightCyan
    }

    var warning: String {
        rawValue.yellow
    }

    var success: String {
        rawValue.lightGreen
    }
}
