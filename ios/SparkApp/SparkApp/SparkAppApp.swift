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
                .environment(delegate.dependencies.sparkManager)
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
    
    let sparkManager: SparkManager
    let habitManager: HabitManager
    let userManager: UsersManager
    let logManager: LogManager

    init(_ config: BuildConfiguration) {
        switch config {
        case .mock:
            logManager   = LogManager(services: [ConsoleService(printParameters: false)])
            sparkManager = SparkManager(service: MockSparkService())
            habitManager = HabitManager(service: MockHabitService())
            userManager  = UsersManager(service: MockUserService(), logManager: logManager)
        case .dev:
            logManager   = LogManager(services: [ConsoleService(printParameters: true)])
            sparkManager = SparkManager(service: SparkServerService())
            habitManager = HabitManager(service: SparkHabitService())
            userManager  = UsersManager(service: SparkUserService(), logManager: logManager)
        case .prod:
            logManager   = LogManager(services: [ConsoleService(printParameters: true)])
            sparkManager = SparkManager(service: SparkServerService())
            habitManager = HabitManager(service: SparkHabitService())
            userManager  = UsersManager(service: SparkUserService(), logManager: logManager)
        }
    }
}

extension View {
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(SparkManager(service: MockSparkService()))
            .environment(HabitManager(service: MockHabitService()))
            .environment(UsersManager(service: MockUserService()))
            .environment(LogManager(services: [ConsoleService(printParameters: false)]))
            .environment(AppState())
    }
}
