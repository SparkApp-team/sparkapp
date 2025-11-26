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
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 20) {
                    Button {
                        isLoggedIn = true
                    } label: {
                        Text("Login")
                            .padding(20)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.callout)
                        
                        Button {
                            goToRegister()
                        } label: {
                            Text("Register Now")
                                .foregroundStyle(.blue)
                        }
                        .offset(x: -4)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 6)
                .background(.ultraThinMaterial)
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
