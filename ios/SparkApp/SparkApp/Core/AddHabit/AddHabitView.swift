//
//  AddHabitView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: AddHabitViewModel
    @FocusState private var isNameFocused: Bool

    /// Called after a habit is successfully created, so the caller can reload.
    let onCreated: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit") {
                    TextField("Name", text: $viewModel.name)
                        .focused($isNameFocused)

                    Picker("Frequency", selection: $viewModel.frequency) {
                        ForEach(HabitFrequency.allCases) { frequency in
                            Text(frequency.title).tag(frequency)
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(AppColors.P2.primary)
                            .font(.callout)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppColors.P2.background)
            .navigationTitle(viewModel.isEditing ? "Edit Habit" : "New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.primary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save {
                            onCreated()
                            dismiss()
                        }
                    }
                    .tint(.primary)
                    .disabled(!viewModel.canSave || viewModel.isSaving)
                }
            }
            .toolbarBackground(AppColors.P2.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            isNameFocused = true
        }
    }
}

#Preview {
    AddHabitView(viewModel: AddHabitViewModel(container: DevPreview.shared.container)) {}
        .previewEnvironment()
}
