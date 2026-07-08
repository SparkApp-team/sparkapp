//
//  SplashViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class SplashViewModel {
    private let appState: AppState
    private let userManager: UserManager

    private(set) var isStart: Bool = false
    private(set) var logoOffset: CGFloat = 0
    private(set) var titleText = ""

    private let fullTitle = "SparkApp"

    init(container: DependencyContainer) {
        self.appState = container.resolve(AppState.self)!
        self.userManager = container.resolve(UserManager.self)!
    }

    func startAnimation() {
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
            appState.updateState(option: restored ? .content : .auth)
        }
    }
}
