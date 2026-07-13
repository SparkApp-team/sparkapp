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
    private let logManager: LogManager
    private let existingHabit: HabitDataModel?

    var name: String = ""
    var frequency: HabitFrequency = .daily
    private(set) var isSaving: Bool = false
    private(set) var errorMessage: String?

    var isEditing: Bool {
        existingHabit != nil
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(container: DependencyContainer, habit: HabitDataModel? = nil) {
        self.habitManager = container.resolve(HabitManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.logManager = container.resolve(LogManager.self)!
        self.existingHabit = habit
        if let habit {
            self.name = habit.name
            self.frequency = HabitFrequency(rawValue: habit.frequency) ?? .daily
        }
    }

    func save(onSuccess: @escaping () -> Void) {
        guard let userId = userManager.currentUser?.id else {
            errorMessage = "No signed-in user."
            return
        }

        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        Task {
            isSaving = true
            defer { isSaving = false }
            do {
                errorMessage = nil
                if let existingHabit {
                    _ = try await habitManager.updateHabit(
                        id: existingHabit.id,
                        userId: userId,
                        name: name,
                        frequency: frequency.rawValue
                    )
                } else {
                    _ = try await habitManager.createHabit(
                        name: name,
                        frequency: frequency.rawValue,
                        userId: userId
                    )
                }
                onSuccess()
            } catch {
                errorMessage = error.localizedDescription
                logManager.trackEvent(eventName: "Error: \(error)",
                                      parameters: ["Message": error.localizedDescription])
            }
        }
    }
}
