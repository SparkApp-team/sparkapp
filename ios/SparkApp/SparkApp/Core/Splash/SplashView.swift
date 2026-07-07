//
//  SplashView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppState.self) private var root
    @Environment(UsersManager.self) private var userManager

    @State var isStart: Bool = false
    @State var logoOffset: CGFloat = 0
    
    @State private var titleText = ""
    private let fullTitle = "SparkApp"
    
    var body: some View {
        logoView
            .onAppear {
                startAnimation()
            }
    }
    
    private var logoView: some View {
        ZStack(alignment: .center) {
            Color(.logoBackground)
            
            Image(.testLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .offset(y: logoOffset)
                .animation(.easeOut(duration: 0.8), value: logoOffset)
            
            Text(titleText)
                .foregroundStyle(AppColors.P2.textPrimary)
                .font(.title2)
                .fontWeight(.semibold)
                .opacity(isStart ? 1 : 0)
                .animation(.easeIn(duration: 0.4), value: isStart)
                .offset(y: 30)
        }
        .ignoresSafeArea()
    }
    
    private func startAnimation() {
        Task {
            try? await Task.sleep(for: .seconds(0.8))
            logoOffset = -40

            try? await Task.sleep(for: .seconds(0.4))
            isStart = true

            typeTitle()
        }
    }

    private func typeTitle() {
        titleText = ""

        Task {
            for letter in fullTitle {
                try? await Task.sleep(for: .seconds(0.08))
                if Task.isCancelled { return }
                titleText.append(letter)
            }

            endAnimation()
        }
    }

    private func endAnimation() {
        Task {
            try? await Task.sleep(for: .seconds(1))
            let restored = await userManager.restoreSession()
            root.updateState(option: restored ? .content : .auth)
        }
    }
}

#Preview {
    SplashView()
        .previewEnvironment()
}
