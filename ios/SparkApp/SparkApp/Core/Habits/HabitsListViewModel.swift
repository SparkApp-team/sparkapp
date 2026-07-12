//
//  HabitsListViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class HabitsListViewModel {
    private let healthManager: HealthManager
    private let habitManager: HabitManager
    private let userManager: UserManager
    private var logManager: LogManager

    private(set) var health: ServerHealthDataModel = .goodMock
    private(set) var habits: [HabitDataModel] = []
    private(set) var isLoading: Bool = true

    init(container: DependencyContainer) {
        self.healthManager = container.resolve(HealthManager.self)!
        self.habitManager = container.resolve(HabitManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.logManager = container.resolve(LogManager.self)!
    }

    func loadHabits() async {
        isLoading = true
        defer { isLoading = false }
        do {
            guard let strUserId = userManager.currentUser?.id, let userId = Int(strUserId) else {
                logManager.trackEvent(
                    eventName: "HabitsView_LoadHabits_NoUser",
                    type: .warning
                )
                return
            }

            habits = try await habitManager.getHabitsForUser(userId: userId)
        } catch {
            logManager.trackEvent(
                eventName: "HabitsView_LoadHabits_Fail",
                parameters: ["error": error.localizedDescription],
                type: .severe
            )
        }
    }

    func checkServerHealth() async {
        do {
            health = try await healthManager.getServerHealth()
            logManager.trackEvent(
                eventName: "HabitsView_ServerHealth",
                parameters: ["status": health.status.rawValue],
                type: .info
            )
        } catch {
            health = ServerHealthDataModel(status: .bad)
            logManager.trackEvent(
                eventName: "HabitsView_ServerHealth_Fail",
                parameters: ["error": error.localizedDescription],
                type: .severe
            )
        }
    }
}
