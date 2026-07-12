//
//  MockHabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

class MockHabitService: HabitService, MockService {
    var habits: [HabitDataModel]
    var delay: Double
    var showError: Bool
    
    init(habits: [HabitDataModel] = HabitDataModel.mocks, delay: Double = 0.0, showError: Bool = false) {
        self.habits = habits
        self.delay = delay
        self.showError = showError
    }

    func createHabit(name: String, frequency: String, userId: Int) async throws -> HabitDataModel {
        try await executionBehaviour()
        let habit = HabitDataModel(id: habits.count + 1, userId: userId, name: name, frequency: frequency)
        habits.append(habit)
        return habit
    }
    
    func deleteHabbit(id: Int) async throws {
        try await executionBehaviour()
        guard let _ = habits.first(where: { $0.id == id }) else {
            throw NSError(
                domain: "Not found",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Index: \(String(describing: index)) was not found. "]
            )
        }
        habits.removeAll(where: { $0.id == id })
        return
    }
    
    func updateHabit(id: Int, name: String, frequency: String) async throws -> HabitDataModel {
        guard let index = habits.firstIndex(where: { $0.id == id }) else {
            throw NSError(
                domain: "Not found",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Index: \(String(describing: index)) was not found. "]
            )
        }
        
        try await executionBehaviour()
        habits[index].name = name
        habits[index].frequency = frequency
        return habits[index]
    }
    
    func getHabit(id: Int, userId: Int) async throws -> HabitDataModel {
        try await executionBehaviour()
        return HabitDataModel.mock
    }

    func getHabitsForUser(userId: Int) async throws -> [HabitDataModel] {
        try await executionBehaviour()
        return habits.filter({ $0.id == userId })
    }
}
