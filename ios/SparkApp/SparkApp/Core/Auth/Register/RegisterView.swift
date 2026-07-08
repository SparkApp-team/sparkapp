//
//  RegisterView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.07.2026.
//

import SwiftUI

struct RegisterView: View {
    @Environment(DependencyContainer.self) private var container
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: RegisterViewModel

    var body: some View {
        VStack {
            ScrollView {
                registerForm
            }

            ctaButtons
        }
        .background(AppColors.P2.background)
        .devMenuToolbar(email: $viewModel.email,
                        password: $viewModel.password,
                        confirmPassword: $viewModel.confirmPassword)
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
                    text: $viewModel.email
                )

                FloatingSecureTextField(
                    leftIcon: "lock.fill",
                    placeholder: "Password",
                    text: $viewModel.password
                )

                FloatingSecureTextField(
                    leftIcon: "lock.fill",
                    placeholder: "Confirm Password",
                    text: $viewModel.confirmPassword
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
            Text("Register")
                .callToActionButton()
                .anyButton {
                    viewModel.onRegisterPressed()
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
}

#Preview {
    NavigationStack {
        RegisterView(viewModel: RegisterViewModel(container: DevPreview.shared.container))
            .previewEnvironment()
    }
}
