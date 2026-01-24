//
//  MockHabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

struct MockHabitService: HabitService, MockService {
    var habits: [HabitDataModel]
    var delay: Double
    var showError: Bool
    
    init(habits: [HabitDataModel] = HabitDataModel.mocks, delay: Double = 0.0, showError: Bool = false) {
        self.habits = habits
        self.delay = delay
        self.showError = showError
    }
    
    func getHabitsForUser(userId: String) async throws -> [HabitDataModel] {
        try await executionBehaviour()
        return habits
    }
}
