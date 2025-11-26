//
//  HabitViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI
import Combine

@MainActor
final class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadHabits() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            habits = try await MockApiClient.shared.getHabits()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func refresh() async {
        await loadHabits()
    }
}
