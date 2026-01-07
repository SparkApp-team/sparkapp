//
//  AppState.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

@Observable
class AppState {
    private(set) var option: AppStateOption {
        didSet {
            UserDefaults.stateOption = option
        }
    }
    
    init(option: AppStateOption = UserDefaults.stateOption) {
        self.option = option
    }
    
    func updateState(option: AppStateOption) {
        self.option = option
    }
}

enum AppStateOption: String {
    case launch
    case auth
    case content
    
    static let `default`: Self = .launch
}

extension UserDefaults {
    private struct Keys {
        static let stateOption = "stateOptionKey"
    }

    static var stateOption: AppStateOption {
        get {
            guard
                let raw = standard.string(forKey: Keys.stateOption),
                let option = AppStateOption(rawValue: raw)
            else {
                return .default
            }
            return option
        }
        set {
            standard.set(newValue.rawValue, forKey: Keys.stateOption)
        }
    }
}
