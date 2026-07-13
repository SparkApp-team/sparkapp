//
//  HabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol HabitService: Sendable {
    func createHabit(name: String, frequency: String, userId: Int) async throws -> HabitDataModel
    func deleteHabbit(id: Int, userId: Int) async throws
    func updateHabit(id: Int, userId: Int, name: String, frequency: String) async throws -> HabitDataModel
    func getHabit(id: Int, userId: Int) async throws -> HabitDataModel
    func getHabitsForUser(userId: Int) async throws -> [HabitDataModel]
}
