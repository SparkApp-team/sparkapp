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
        Task {
            do {
                //Email validation
                let validatedEmail = try validateEmail(email)
                
                //Password & Confirm password validation
                let validatedPassword = try validatePassword(password)
                let confirmPassword = try validatePassword(confirmPassword)
                
                //Password mismatch
                if validatedPassword != confirmPassword {
                    errorMessage = "Passwords don't match."
                    return
                }
                
                errorMessage = nil
                _ = try await userManager.registerUser(email: validatedEmail, password: validatedPassword)
                appState.updateState(option: .content)
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
        
        //Email format
        let emailPattern = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        if email.wholeMatch(of: emailPattern) == nil {
            throw EmailValidationError.invalidFormat
        }
        
        //Email domain
        let notAllowedDomains: Set<String> = ["yandex.com"]
        if let emailDomain = email.split(separator: "@").last, notAllowedDomains.contains(String(emailDomain).lowercased()) {
            throw EmailValidationError.domainNotAllowed
        }
        
        return email
    }
    
    enum EmailValidationError: Error, LocalizedError {
        case empty
        case invalidFormat
        case domainNotAllowed
        
        var errorDescription: String? {
            switch self {
            case .empty:
                return "Email is empty."
            case .invalidFormat:
                return "Invalid email format."
            case .domainNotAllowed:
                return "Email domain is not allowed."
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
        
        //Password 8 characters long
        if password.count < 8 {
            throw PasswordValidationError.tooShort
        }
        
        return password
    }
    
    enum PasswordValidationError: Error, LocalizedError {
        case empty
        case tooShort
        
        var errorDescription: String? {
            switch self {
            case .empty:
                return "Password is empty."
            case .tooShort:
                return "Password must be at least 8 characters long."
            }
        }
    }
}
