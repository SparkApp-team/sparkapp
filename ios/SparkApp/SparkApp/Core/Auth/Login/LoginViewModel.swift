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
                //Email validation
                let validatedEmail = try validateEmail(email)
                
                //Password validation
                let validatedPassword = try validatePassword(password)
                
                errorMessage = nil
                try await userManager.login(email: validatedEmail, password: validatedPassword)
                if let _ = userManager.currentUser {
                    appState.updateState(option: .content)
                }
            } catch {
                errorMessage = error.localizedDescription
                logManager.trackEvent(eventName: "Error: \(error)",
                                      parameters: ["Message": error.localizedDescription])
            }
        }
    }
    
    private func validateEmail(_ email: String) throws -> String {
        //Clean email
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Email empty
        if email.isEmpty {
            throw EmailValidationError.empty
        }
        
        return email
    }
    
    enum EmailValidationError: Error, LocalizedError {
        case empty
        
        var errorDescription: String? {
            switch self {
            case .empty:
                return "Email is empty."
            }
        }
    }
    
    private func validatePassword(_ password: String) throws -> String {
        //Clean password
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Password empty
        if password.isEmpty {
            throw PasswordValidationError.empty
        }
        
        return password
    }
    
    enum PasswordValidationError: Error, LocalizedError {
        case empty
        
        var errorDescription: String? {
            switch self {
            case .empty:
                return "Password is empty."
            }
        }
    }
}
