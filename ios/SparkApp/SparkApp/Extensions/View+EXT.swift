//
//  View+EXT.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

extension View {
    func marked() -> some View {
        self
            .background(Color.random())
    }
    
    func anyButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(.plain)
    }
    
    func callToActionButton() -> some View {
        self
            .font(.title2)
            .foregroundStyle(AppColors.P2.background)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(AppColors.P2.primary)
            .cornerRadius(16)
    }
}
