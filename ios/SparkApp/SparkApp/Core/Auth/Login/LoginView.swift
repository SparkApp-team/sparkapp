//
//  LoginView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var root
    @Environment(UserManager.self) private var userManager
    @Environment(LogManager.self) private var logManager

    private enum Field {
        case email
        case password
    }

    @State var email: String = ""
    @State var password: String = ""
    @State private var errorMessage: String?
    //@FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    loginForm
                }

                ctaButtons
            }
            .background(AppColors.P2.background)
            .devMenuToolbar(email: $email, password: $password)
        }
    }

    private var loginForm: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("Welcome back! Glad to see you, Again!")
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
            Text("Login")
                .callToActionButton()
                .anyButton {
                    onLoginPressed()
                }
    
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundStyle(AppColors.P2.textSecondary)
                    .font(.callout)
                
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("Register Now")
                        .foregroundStyle(AppColors.P2.secondary)
                }

            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private func onLoginPressed() {
        Task {
            do {
                errorMessage = nil
                try await userManager.login(email: email, password: password)
                if let _ = userManager.currentUser {
                    root.updateState(option: .content)
                }
            } catch let error as APIError {
                errorMessage = error.errorDescription
                logManager.trackEvent(eventName: "Error: \(error)", parameters: ["Message": error.errorDescription ?? "No message"])
            }
        }
    }
}

#Preview {
    LoginView(email: "", password: "")
        .environment(AppState())
        .previewEnvironment()
}
