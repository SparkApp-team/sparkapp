//
//  FloatingTextField.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct FloatingTextField: View {
    
    var leftIcon: String? = nil
    var rightIcon: String? = nil
    
    var placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    private var isFloated: Bool {
        isFocused || !text.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if let icon = leftIcon {
                    Image(systemName: icon)
                        .foregroundStyle(AppColors.P2.textSecondary)
                }
                
                TextField("", text: $text)
                    .foregroundStyle(AppColors.P2.textPrimary)
                    .focused($isFocused)
                    .frame(height: 22)
                
                if let icon = rightIcon {
                    Image(systemName: icon)
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

#Preview {
    @Previewable @State var text: String = ""
    FloatingTextField(leftIcon: "person.fill", rightIcon: nil, placeholder: "sometext", text: $text)
}
