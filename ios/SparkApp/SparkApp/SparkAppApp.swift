//
//  SparkAppApp.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 22.11.2025.
//

import SwiftUI

@main
struct SparkAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(AppState())
                .environment(delegate.dependencies.healthManager)
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.habitManager)
                .environment(delegate.dependencies.logManager)
        }
    }
}

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

@MainActor
struct AppDependencies {
    
    let healthManager: HealthManager
    let habitManager: HabitManager
    let userManager: UsersManager
    let logManager: LogManager

    init(_ config: BuildConfiguration) {
        switch config {
        case .mock:
            logManager    = LogManager(services: [ConsoleService(printParameters: false)])
            healthManager = HealthManager(service: MockHealthService())
            userManager   = UsersManager(service: MockUserService(), logManager: logManager)
            habitManager  = HabitManager(service: MockHabitService())
        case .dev:
            logManager    = LogManager(services: [ConsoleService(printParameters: true)])
            healthManager = HealthManager(service: SparkHealthService())
            userManager   = UsersManager(service: SparkUserService(), logManager: logManager)
            habitManager  = HabitManager(service: SparkHabitService())
        case .prod:
            logManager    = LogManager(services: [ConsoleService(printParameters: true)])
            healthManager = HealthManager(service: SparkHealthService())
            userManager   = UsersManager(service: SparkUserService(), logManager: logManager)
            habitManager  = HabitManager(service: SparkHabitService())
        }
    }
}

extension View {
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(HealthManager(service: MockHealthService()))
            .environment(HabitManager(service: MockHabitService()))
            .environment(UsersManager(service: MockUserService()))
            .environment(LogManager(services: [ConsoleService(printParameters: false)]))
            .environment(AppState())
    }
}
