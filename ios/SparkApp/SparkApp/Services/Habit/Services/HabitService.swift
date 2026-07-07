//
//  HabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol HabitService: Sendable {
    func createHabit(name: String, frequency: String, userId: String) async throws -> HabitDataModel
    func getHabitsForUser(userId: String) async throws -> [HabitDataModel]
}
