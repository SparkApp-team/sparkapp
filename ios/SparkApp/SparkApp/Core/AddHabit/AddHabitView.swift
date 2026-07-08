//
//  AddHabitView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(HabitManager.self) private var habitManager
    @Environment(UsersManager.self) private var userManager

    /// Called after a habit is successfully created, so the caller can reload.
    let onCreated: () -> Void

    @State private var name: String = ""
    @State private var frequency: Frequency = .daily
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?

    enum Frequency: String, CaseIterable, Identifiable {
        case daily, weekly, monthly
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit") {
                    TextField("Name", text: $name)

                    Picker("Frequency", selection: $frequency) {
                        ForEach(Frequency.allCases) { frequency in
                            Text(frequency.title).tag(frequency)
                        }
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(AppColors.P2.primary)
                            .font(.callout)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }
                        .disabled(!canSave || isSaving)
                }
            }
        }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func save() {
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
                onCreated()
                dismiss()
            } catch let error as APIError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = "Something went wrong. Please try again."
            }
        }
    }
}

#Preview {
    AddHabitView(onCreated: {})
        .previewEnvironment()
}
