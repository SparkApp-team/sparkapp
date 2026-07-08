//
//  DependencyContainer.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class DependencyContainer {
    var services: [String: Any] = [:]

    func register<T>(_ service: T) {
        let key = "\(T.Type.self)"
        services[key] = service
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return services[key] as? T
    }
}
