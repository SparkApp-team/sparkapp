//
//  HabitManager.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

@MainActor
@Observable
class HabitManager {

    var service: HabitService
    private let logManager: LogManager?

    init(service: HabitService, logManager: LogManager? = nil) {
        self.service = service
        self.logManager = logManager
    }

    func getHabitsForUser(userId: String) async throws -> [HabitDataModel] {
        logManager?.trackEvent(event: Event.getHabitsStart(userId: userId))
        do {
            let habits = try await service.getHabitsForUser(userId: userId)
            logManager?.trackEvent(event: Event.getHabitsSuccess(habits: habits))
            return habits
        } catch {
            logManager?.trackEvent(event: Event.getHabitsFail(error: error))
            throw error
        }
    }

    func createHabit(name: String, frequency: String, userId: String) async throws -> HabitDataModel {
        logManager?.trackEvent(event: Event.createHabitStart)
        do {
            let habit = try await service.createHabit(name: name, frequency: frequency, userId: userId)
            logManager?.trackEvent(event: Event.createHabitSuccess(habit: habit))
            return habit
        } catch {
            logManager?.trackEvent(event: Event.createHabitFail(error: error))
            throw error
        }
    }
}

extension HabitManager {
    enum Event: LoggableEvent {
        case getHabitsStart(userId: String)
        case getHabitsSuccess(habits: [HabitDataModel])
        case getHabitsFail(error: Error)
        case createHabitStart
        case createHabitSuccess(habit: HabitDataModel)
        case createHabitFail(error: Error)

        var eventName: String {
            switch self {
            case .getHabitsStart:     "HabitManager_GetHabits_Start"
            case .getHabitsSuccess:   "HabitManager_GetHabits_Success"
            case .getHabitsFail:      "HabitManager_GetHabits_Fail"
            case .createHabitStart:   "HabitManager_CreateHabit_Start"
            case .createHabitSuccess: "HabitManager_CreateHabit_Success"
            case .createHabitFail:    "HabitManager_CreateHabit_Fail"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .getHabitsStart(let userId):
                ["user_id": userId]
            case .getHabitsSuccess(let habits):
                ["habits_count": habits.count]
            case .createHabitSuccess(let habit):
                habit.eventParameters
            case .getHabitsFail(let error), .createHabitFail(let error):
                ["error": error.localizedDescription]
            default:
                nil
            }
        }

        var type: LogType {
            switch self {
            case .getHabitsFail, .createHabitFail:
                    .severe
            default:
                    .analytic
            }
        }
    }
}
