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
    
    init(service: HabitService) {
        self.service = service
    }
    
    func getHabitsForUser(userId: String) async throws -> [HabitDataModel] {
        try await service.getHabitsForUser(userId: userId)
    }
}
