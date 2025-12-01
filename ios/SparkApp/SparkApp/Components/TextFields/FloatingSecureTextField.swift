//
//  FloatingSecureTextField.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct FloatingSecureTextField: View {

    var leftIcon: String? = nil
    
    var placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    private var isFloated: Bool {
        isFocused || !text.isEmpty
    }
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if(leftIcon != nil) {
                    Image(systemName: leftIcon ?? "person")
                        .foregroundStyle(AppColors.P2.textSecondary)
                }
                
                ZStack {
                    SecureField("", text: $text)
                        .foregroundStyle(AppColors.P2.textPrimary)
                        .opacity(isSecure ? 0 : 1)
                        .focused($isFocused)
                    TextField("", text: $text)
                        .foregroundStyle(AppColors.P2.textPrimary)
                        .opacity(isSecure ? 1 : 0)
                        .focused($isFocused)
                }
                
                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(AppColors.P2.textSecondary)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(AppColors.P2.textSecondary))
            
            Text(placeholder)
                .foregroundStyle(AppColors.P2.textSecondary)
                .background(AppColors.P2.background).padding(-3)
                .offset(x: isFloated ? (leftIcon != nil ? 15 : 15) : (leftIcon != nil ? 45 : 15))
                .offset(y:isFloated ? -30 : 0)
                .animation(.easeInOut(duration: 0.22), value: isFloated)
                .onTapGesture { isFocused = true }
        }
        .padding(.top, 12)
    }
}
