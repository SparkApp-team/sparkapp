//
//  RegisterViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class RegisterViewModel {
    private let appState: AppState
    private let userManager: UserManager
    private var logManager: LogManager

    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }

    private(set) var errorMessage: String?

    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    init(container: DependencyContainer) {
        self.appState = container.resolve(AppState.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.logManager = container.resolve(LogManager.self)!
    }

    func onRegisterPressed() {
        guard passwordsMatch else {
            errorMessage = "Passwords don't match."
            return
        }

        Task {
            do {
                errorMessage = nil
                _ = try await userManager.registerUser(email: email, password: password)
                appState.updateState(option: .content)
            } catch let error as APIError {
                errorMessage = error.errorDescription
                logManager.trackEvent(
                    eventName: "Error: \(error)",
                    parameters: ["Message": error.errorDescription ?? "No message"]
                )
            }
        }
    }
}
