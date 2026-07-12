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

    /// Called after a habit is successfully created, so the caller can reload.
    let onCreated: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit") {
                    TextField("Name", text: $viewModel.name)

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
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save {
                            onCreated()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.canSave || viewModel.isSaving)
                }
            }
        }
    }
}

#Preview {
    AddHabitView(viewModel: AddHabitViewModel(container: DevPreview.shared.container)) {}
        .previewEnvironment()
}
