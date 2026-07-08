//
//  AppDelegate.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: AppDependencies!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let config: BuildConfiguration

        #if MOCK
        config = .mock(isSignedIn: true)
        #elseif DEV
        config = .dev
        #else
        config = .prod
        #endif

        config.configure()
        dependencies = AppDependencies(config)
        return true
    }
}

enum BuildConfiguration {
    case mock(isSignedIn: Bool), dev, prod

    // For dev + prod add a configurations for api.
    func configure() {
        switch self {
        case .mock:
            break
        case .dev:
            break
        case .prod:
            break
        }
    }
}
