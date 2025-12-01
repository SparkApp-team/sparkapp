//
//  EmptyView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        Color(AppColors.P2.background)
        
        Text("Registration.")
            .foregroundStyle(AppColors.P2.textPrimary)
            .font(.largeTitle)
            .padding()
    }
}
