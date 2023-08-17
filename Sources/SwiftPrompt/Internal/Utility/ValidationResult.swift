//
//  ValidationResult.swift
//
//
//  Created by CheekyGhost Labs on 16/8/2023.
//

import Foundation

/// Enumeration of supported validation handler results.
public enum ValidationResult {
    case valid
    case invalid(message: String)
}
