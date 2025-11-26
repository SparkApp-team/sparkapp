//
//  HabitListView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

//Fix:
//1. normal loading animation + background

struct HabitListView: View {
    @StateObject private var viewModel = HabitViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading habits...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.habits) { habit in
                        Text(habit.name)
                    }
                }
            }
            .navigationTitle("Habits")
            .task {
                await viewModel.loadHabits()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}
