//
//  EmptyView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        Color(AppColors.P2.background)
            .ignoresSafeArea()
        
        Text("Registration.")
            .foregroundStyle(AppColors.P2.textPrimary)
            .font(.largeTitle)
            .padding()
    }
}
