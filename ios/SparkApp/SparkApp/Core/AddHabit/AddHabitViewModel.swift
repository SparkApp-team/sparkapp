//
//  AddHabitViewModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

@MainActor
@Observable
class AddHabitViewModel {
    private let habitManager: HabitManager
    private let userManager: UserManager

    var name: String = ""
    var frequency: Frequency = .daily
    private(set) var isSaving: Bool = false
    private(set) var errorMessage: String?

    enum Frequency: String, CaseIterable, Identifiable {
        case daily, weekly, monthly
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(container: DependencyContainer) {
        self.habitManager = container.resolve(HabitManager.self)!
        self.userManager = container.resolve(UserManager.self)!
    }

    /// Creates the habit and, on success, invokes `onSuccess` so the view can
    /// reload the caller and dismiss.
    func save(onSuccess: @escaping () -> Void) {
        guard let userId = userManager.currentUser?.id else {
            errorMessage = "No signed-in user."
            return
        }

        Task {
            isSaving = true
            defer { isSaving = false }
            do {
                errorMessage = nil
                _ = try await habitManager.createHabit(
                    name: name.trimmingCharacters(in: .whitespaces),
                    frequency: frequency.rawValue,
                    userId: userId
                )
                onSuccess()
            } catch let error as APIError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = "Something went wrong. Please try again."
            }
        }
    }
}
