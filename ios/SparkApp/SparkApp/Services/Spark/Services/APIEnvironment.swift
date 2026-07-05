//
//  APIEnvironment.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 05.07.2026.
//

import Foundation

enum APIEnvironment: String, Sendable, CaseIterable {
    case dima, roma

    var baseURL: URL {
        switch self {
        case .dima:
            URL(string: "https://expansion-sponge-gift.ngrok-free.dev")!
        case .roma:
            URL(string: "https://thirty-feed-oak.ngrok-free.dev")!
        }
    }

    static let `default`: Self = .dima

    static var current: APIEnvironment {
        get { UserDefaults.apiEnvironment }
        set { UserDefaults.apiEnvironment = newValue }
    }
}

extension UserDefaults {
    private struct Keys {
        static let apiEnvironment = "apiEnvironmentKey"
    }

    static var apiEnvironment: APIEnvironment {
        get {
            guard
                let raw = standard.string(forKey: Keys.apiEnvironment),
                let env = APIEnvironment(rawValue: raw)
            else {
                return .default
            }
            return env
        }
        set {
            standard.set(newValue.rawValue, forKey: Keys.apiEnvironment)
        }
    }
}
