//
//  AppViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class AppViewModel {
    private let appState: AppState

    var stateOption: AppStateOption {
        appState.option
    }

    init(container: DependencyContainer) {
        self.appState = container.resolve(AppState.self)!
    }

    
}
