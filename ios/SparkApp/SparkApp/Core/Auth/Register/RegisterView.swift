//
//  RegisterView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.07.2026.
//

import SwiftUI

struct RegisterView: View {
    @Environment(AppState.self) private var root
    @Environment(UsersManager.self) private var userManager
    @Environment(LogManager.self) private var logManager
    @Environment(\.dismiss) private var dismiss

    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State private var errorMessage: String?

    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }

    var body: some View {
        VStack {
            ScrollView {
                registerForm
            }

            ctaButtons
        }
        .background(AppColors.P2.background)
        .devMenuToolbar(email: $email, password: $password, confirmPassword: $confirmPassword)
    }

    private var registerForm: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("Hello! Register to get started")
                .foregroundStyle(AppColors.P2.textPrimary)
                .font(.title)
                .padding(.top, 80)

            VStack(spacing: 28) {
                FloatingTextField(
                    leftIcon: "person.fill",
                    placeholder: "Email",
                    text: $email
                )

                FloatingSecureTextField(
                    leftIcon: "lock.fill",
                    placeholder: "Password",
                    text: $password
                )

                FloatingSecureTextField(
                    leftIcon: "lock.fill",
                    placeholder: "Confirm Password",
                    text: $confirmPassword
                )

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(AppColors.P2.primary)
                        .font(.callout)
                }
            }
        }
        .padding(.horizontal)
    }

    private var ctaButtons: some View {
        VStack(spacing: 10) {
            Text("Register")
                .callToActionButton()
                .anyButton {
                    onRegisterPressed()
                }

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundStyle(AppColors.P2.textSecondary)
                    .font(.callout)

                Text("Login Now")
                    .foregroundStyle(AppColors.P2.secondary)
                    .anyButton {
                        dismiss()
                    }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private func onRegisterPressed() {
        guard passwordsMatch else {
            errorMessage = "Passwords don't match."
            return
        }

        Task {
            do {
                errorMessage = nil
                _ = try await userManager.registerUser(email: email, password: password)
                // NOTE: registerUser returns the user but does not set
                // UsersManager.currentUser (unlike login). See summary.
                root.updateState(option: .content)
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

#Preview {
    NavigationStack {
        RegisterView(email: "", password: "")
            .environment(AppState())
            .previewEnvironment()
    }
}
