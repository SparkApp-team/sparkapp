//
//  LoginViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class LoginViewModel {
    private let appState: AppState
    private let userManager: UserManager
    private var logManager: LogManager

    private(set) var errorMessage: String?

    var email: String = ""
    var password: String = ""

    init(container: DependencyContainer) {
        self.appState = container.resolve(AppState.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.logManager = container.resolve(LogManager.self)!
    }

    func onLoginPressed() {
        Task {
            do {
                errorMessage = nil
                try await userManager.login(email: email, password: password)
                if let _ = userManager.currentUser {
                    appState.updateState(option: .content)
                }
            } catch let error as APIError {
                errorMessage = error.errorDescription
                logManager.trackEvent(eventName: "Error: \(error)", parameters: ["Message": error.errorDescription ?? "No message"])
            }
        }
    }
}
