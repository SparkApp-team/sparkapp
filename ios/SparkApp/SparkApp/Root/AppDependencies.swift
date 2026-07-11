//
//  AppDependencies.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
struct AppDependencies {

    var container: DependencyContainer
    let healthManager: HealthManager
    let habitManager: HabitManager
    let userManager: UserManager
    let logManager: LogManager
    let appState: AppState

    init(_ config: BuildConfiguration) {
        switch config {
        case .mock:
            logManager    = LogManager(services: [ConsoleService(printParameters: false)])
            healthManager = HealthManager(service: MockHealthService(), logManager: logManager)
            userManager   = UserManager(service: MockUserService(), logManager: logManager)
            habitManager  = HabitManager(service: MockHabitService(), logManager: logManager)
        case .dev:
            logManager    = LogManager(services: [ConsoleService(printParameters: true)])
            healthManager = HealthManager(service: SparkHealthService(), logManager: logManager)
            userManager   = UserManager(service: SparkUserService(), logManager: logManager)
            habitManager  = HabitManager(service: SparkHabitService(), logManager: logManager)
        case .prod:
            logManager    = LogManager(services: [ConsoleService(printParameters: true)])
            healthManager = HealthManager(service: SparkHealthService(), logManager: logManager)
            userManager   = UserManager(service: SparkUserService(), logManager: logManager)
            habitManager  = HabitManager(service: SparkHabitService(), logManager: logManager)
        }

        appState = AppState()

        let container = DependencyContainer()
        container.register(HealthManager.self, service: healthManager)
        container.register(HabitManager.self, service: habitManager)
        container.register(UserManager.self, service: userManager)
        container.register(LogManager.self, service: logManager)
        container.register(AppState.self, service: appState)
        self.container = container
    }
}

extension View {
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(DevPreview.shared.container)
    }
}

@MainActor
class DevPreview {
    static let shared = DevPreview()

    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(HealthManager.self, service: healthManager)
        container.register(HabitManager.self, service: habitManager)
        container.register(UserManager.self, service: userManager)
        container.register(LogManager.self, service: logManager)
        container.register(AppState.self, service: appState)
        return container
    }

    let healthManager: HealthManager
    let habitManager: HabitManager
    let userManager: UserManager
    let logManager: LogManager
    let appState: AppState

    init() {
        self.healthManager = HealthManager(service: MockHealthService())
        self.habitManager = HabitManager(service: MockHabitService())
        self.userManager = UserManager(service: MockUserService())
        self.logManager = LogManager(services: [])
        self.appState = AppState()
    }
}
