//
//  HabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol HabitService: Sendable {
    func getHabitsForUser(userId: String) async throws -> [HabitDataModel]
}
