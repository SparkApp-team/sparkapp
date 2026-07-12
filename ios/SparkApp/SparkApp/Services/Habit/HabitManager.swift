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

    func getHabitsForUser(userId: Int) async throws -> [HabitDataModel] {
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

    func createHabit(name: String, frequency: String, userId: Int) async throws -> HabitDataModel {
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
    
    func deleteHabbit(id: Int, userId: Int) async throws {
        logManager?.trackEvent(event: Event.deleteHabitStart(id: id, userId: userId))
        do {
            try await service.deleteHabbit(id: id, userId: userId)
            logManager?.trackEvent(event: Event.deleteHabitSuccess(id: id, userId: userId))
        } catch {
            logManager?.trackEvent(event: Event.deleteHabitFail(error: error))
            throw error
        }
    }
    
    func updateHabit(id: Int, userId: Int, name: String, frequency: String) async throws -> HabitDataModel {
        logManager?.trackEvent(event: Event.updateHabitStart(id: id))
        do {
            let habit = try await service.updateHabit(id: id, userId: userId, name: name, frequency: frequency)
            logManager?.trackEvent(event: Event.updateHabitSuccess(habbit: habit))
            return habit
        } catch {
            logManager?.trackEvent(event: Event.updateHabitFail(error: error))
            throw error
        }
    }
    
    func getHabit(id: Int, userId: Int) async throws -> HabitDataModel {
        logManager?.trackEvent(event: Event.getHabitStart(id: id, userId: userId))
        do {
            let habit = try await service.getHabit(id: id, userId: userId)
            logManager?.trackEvent(event: Event.getHabitSuccess(habit: habit))
            return habit
        } catch {
            logManager?.trackEvent(event: Event.getHabitFail(error: error))
            throw error
        }
    }
}

extension HabitManager {
    enum Event: LoggableEvent {
        case getHabitsStart(userId: Int)
        case getHabitsSuccess(habits: [HabitDataModel])
        case getHabitsFail(error: Error)
        case getHabitStart(id: Int, userId: Int)
        case getHabitSuccess(habit: HabitDataModel)
        case getHabitFail(error: Error)
        case createHabitStart
        case createHabitSuccess(habit: HabitDataModel)
        case createHabitFail(error: Error)
        case deleteHabitStart(id: Int, userId: Int)
        case deleteHabitSuccess(id: Int, userId: Int)
        case deleteHabitFail(error: Error)
        case updateHabitStart(id: Int)
        case updateHabitSuccess(habbit: HabitDataModel)
        case updateHabitFail(error: Error)

        var eventName: String {
            switch self {
            case .getHabitsStart:     "HabitManager_GetHabits_Start"
            case .getHabitsSuccess:   "HabitManager_GetHabits_Success"
            case .getHabitsFail:      "HabitManager_GetHabits_Fail"
            case .getHabitStart:      "HabitManager_GetHabit_Start"
            case .getHabitSuccess:    "HabitManager_GetHabit_Success"
            case .getHabitFail:       "HabitManager_GetHabit_Fail"
            case .createHabitStart:   "HabitManager_CreateHabit_Start"
            case .createHabitSuccess: "HabitManager_CreateHabit_Success"
            case .createHabitFail:    "HabitManager_CreateHabit_Fail"
            case .deleteHabitStart:   "HabitManager_DeleteHabit_Start"
            case .deleteHabitSuccess: "HabitManager_DeleteHabit_Success"
            case .deleteHabitFail:    "HabitManager_DeleteHabit_Fail"
            case .updateHabitStart:   "HabitManager_UpdateHabit_Start"
            case .updateHabitSuccess: "HabitManager_UpdateHabit_Success"
            case .updateHabitFail:    "HabitManager_UpdateHabit_Fail"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .getHabitsStart(let userId):
                ["user_id": userId]
            case .getHabitStart(id: let id, userId: let userId), .deleteHabitStart(id: let id, userId: let userId), .deleteHabitSuccess(id: let id, userId: let userId):
                ["id": id, "user_id": userId]
            case .getHabitsSuccess(let habits):
                ["habits_count": habits.count]
            case .createHabitSuccess(let habit), .updateHabitSuccess(let habit), .getHabitSuccess(let habit):
                habit.eventParameters
            case .getHabitsFail(let error), .createHabitFail(let error):
                ["error": error.localizedDescription]
            case .updateHabitStart(id: let id):
                ["id": id]
            default:
                nil
            }
        }

        var type: LogType {
            switch self {
            case .getHabitsFail, .createHabitFail, .deleteHabitFail, .updateHabitFail, .getHabitFail:
                    .severe
            default:
                    .analytic
            }
        }
    }
}
