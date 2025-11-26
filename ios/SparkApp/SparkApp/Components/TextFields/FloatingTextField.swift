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
                        .foregroundStyle(Color.secondary)
                }
                
                TextField("", text: $text)
                    .focused($isFocused)
                    .frame(height: 22)
                
                if let icon = rightIcon {
                    Image(systemName: icon)
                        .foregroundStyle(Color.secondary)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black))
            
            Text(placeholder)
                .foregroundStyle(Color.secondary)
                .background(Color(UIColor.systemBackground).padding(-3))
                .offset(x: isFloated ? (leftIcon != nil ? 15 : 15) : (leftIcon != nil ? 45 : 15))
                .offset(y:isFloated ? -30 : 0)
                .animation(.easeInOut(duration: 0.22), value: isFloated)
                .onTapGesture { isFocused = true }
        }
        .padding(.top, 12)
    }
}
