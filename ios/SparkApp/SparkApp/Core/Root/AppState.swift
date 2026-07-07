//
//  AppState.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

@Observable
class AppState {
    private(set) var option: AppStateOption

    init(option: AppStateOption = .default) {
        self.option = option
    }

    func updateState(option: AppStateOption) {
        self.option = option
    }
}

enum AppStateOption: String, CaseIterable {
    case launch
    case auth
    case content

    static let `default`: Self = .launch
}
