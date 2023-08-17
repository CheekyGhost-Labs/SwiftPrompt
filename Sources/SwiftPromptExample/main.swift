//
//  main.swift
//
//
//  Created by CheekyGhost Labs on 16/8/2023.
//

import SwiftPrompt

// Start a prompt group
Prompt.startPromptGroup(title: "Sign Up and Fruit:")

// Ask for username
let username = Prompt.textInput(
    question: "What is your email address?",
    placeholder: "This input will have not-empty validation",
    isSecureEntry: false,
    validator: {
        if !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Please enter something")
        }
    }
)

// Ask for password
let password = Prompt.textInput(
    question: "Enter a password:",
    placeholder: "Enter something secure with at least 8 characters",
    isSecureEntry: true,
    validator: {
        if $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 {
            return .valid
        } else {
            return .invalid(message: "Passwords should be at least 8 characters long")
        }
    }
)

// MARK: - Fruit Selection

enum Fruit: CaseIterable {
    case apple
    case banana
    case orange
    case tomato

    var title: String {
        switch self {
        case .apple:
            return "🍎 Apple"
        case .banana:
            return "🍌 Banana"
        case .orange:
            return "🍊 Orange"
        case .tomato:
            return "🍅 Tomato"
        }
    }

    var option: PromptOption<Fruit> {
        return .init(title: title, value: self)
    }
}

// Ask for favourite fruit selection

let option = Prompt.selectOption(
    question: "Select your favourite fruit",
    options: Fruit.allCases.map(\.option)
)

// General output/update
Prompt.writeGroupUpdate(title: "Information gathered...")

// Close group
Prompt.endPromptGroup(title: "Username: \(username ?? "not provided"), Password: \(password ?? "not provided"), Fruit: \(option.title)".onGreen)
