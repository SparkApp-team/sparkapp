//
//  LoginView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(DependencyContainer.self) private var container
    @State var viewModel: LoginViewModel

    private enum Field {
        case email
        case password
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    loginForm
                }

                ctaButtons
            }
            .background(AppColors.P2.background)
            .devMenuToolbar(email: $viewModel.email,
                            password: $viewModel.password)
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
                    text: $viewModel.email
                )
                
                FloatingSecureTextField(
                    leftIcon: "lock.fill",
                    placeholder: "Password",
                    text: $viewModel.password
                )

                if let errorMessage = viewModel.errorMessage {
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
                    viewModel.onLoginPressed()
                }
    
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundStyle(AppColors.P2.textSecondary)
                    .font(.callout)
                
                NavigationLink {
                    RegisterView(viewModel: RegisterViewModel(container: container))
                } label: {
                    Text("Register Now")
                        .foregroundStyle(AppColors.P2.secondary)
                }

            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(container: DevPreview.shared.container))
        .previewEnvironment()
}
