//
//  LoginView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

//Fix:
//1. dark theme;
//2. keyboard focusing for text fields;
//3. design

struct LoginView: View {
    
    enum Field {
        case email
        case password
    }
    
    @Binding var isLoggedIn: Bool
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State private var navigateToRegister = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    Text("")
                    
                    Text("Welcome back! Glad to see you, Again!")
                        .foregroundStyle(AppColors.P2.textPrimary)
                        .font(.title)
                        .padding(.top, 40)
                    
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
                    
                    Spacer().frame(height: 40)
                }
                .padding(.horizontal)
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(AppColors.P2.background)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 20) {
                    Button {
                        isLoggedIn = true
                    } label: {
                        Text("Login")
                            .padding(20)
                            .foregroundStyle(AppColors.P2.background)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.P2.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(AppColors.P2.textSecondary)
                            .font(.callout)
                        
                        Button {
                            goToRegister()
                        } label: {
                            Text("Register Now")
                                .foregroundStyle(AppColors.P2.secondary)
                        }
                        .offset(x: -4)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 6)
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                EmptyView()
            }
        }
    }
    
    private func goToRegister() {
        navigateToRegister = true
    }
}

#Preview {
    @Previewable @State var logged: Bool = false
    LoginView(isLoggedIn: $logged, email: "", password: "")
}
