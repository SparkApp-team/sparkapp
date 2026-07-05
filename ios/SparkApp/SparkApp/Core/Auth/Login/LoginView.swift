//
//  LoginView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var root
    @Environment(SparkManager.self) private var sparkManager

    private enum Field {
        case email
        case password
    }

    @State var email: String = ""
    @State var password: String = ""
    #if DEBUG
    @State private var selectedEnvironment: APIEnvironment = .current
    #endif
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
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    devMenu
                }
            }
            #endif
        }
    }

    #if DEBUG
    private var devMenu: some View {
        Menu {
            ForEach(APIEnvironment.allCases, id: \.self) { env in
                Button {
                    selectEnvironment(env)
                } label: {
                    if env == selectedEnvironment {
                        Label(env.rawValue, systemImage: "checkmark")
                    } else {
                        Text(env.rawValue)
                    }
                }
            }
        } label: {
            Label("Dev Menu", systemImage: "hammer.fill")
        }
    }

    private func selectEnvironment(_ env: APIEnvironment) {
        selectedEnvironment = env
        APIEnvironment.current = env
        sparkManager.service = SparkServerService(environment: env)
    }
    #endif

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
                    EmptyView()
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
            try? await Task.sleep(for: .seconds(2))
            root.updateState(option: .content)
        }
    }
}

#Preview {
    LoginView(email: "", password: "")
        .environment(AppState())
        .previewEnvironment()
}
