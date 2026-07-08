//
//  SplashView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct SplashView: View {
    @Environment(DependencyContainer.self) private var container
    @State var viewModel: SplashViewModel

    var body: some View {
        logoView
            .onAppear {
                viewModel.startAnimation()
            }
    }
    
    private var logoView: some View {
        ZStack(alignment: .center) {
            Color(.logoBackground)
            
            Image(.testLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .offset(y: viewModel.logoOffset)
                .animation(.easeOut(duration: 0.8), value: viewModel.logoOffset)

            Text(viewModel.titleText)
                .foregroundStyle(AppColors.P2.textPrimary)
                .font(.title2)
                .fontWeight(.semibold)
                .opacity(viewModel.isStart ? 1 : 0)
                .animation(.easeIn(duration: 0.4), value: viewModel.isStart)
                .offset(y: 30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel(container: DevPreview.shared.container))
        .previewEnvironment()
}
