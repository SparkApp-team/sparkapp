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
    
    var titles = ["First Section" : ["Manage your workout", "View recorded workouts", "Weight tracker", "Mediation"], "Second Section" : ["Your workout", "Recorded workouts", "Tracker", "Mediations"]]
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: AppColors.P2.textPrimary.uiColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: AppColors.P2.textPrimary.uiColor]
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading habits...")
                            .foregroundStyle(AppColors.P2.textPrimary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        VStack(spacing: 0) {
                            ForEach(viewModel.habits) { habit in
                                HStack {
                                    Text(habit.name)
                                        .foregroundColor(AppColors.P2.textPrimary)
                                    Spacer()
                                }
                                .padding()
                                
                                if habit.id != viewModel.habits.last?.id {
                                    Divider()
                                        .background(AppColors.P2.textPrimary)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.P2.secondaryBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.P2.textPrimary, lineWidth: 1)
                                )
                        )
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 4)
                    }
                    .scrollContentBackground(.hidden)
                    .background(AppColors.P2.background)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Habits")
            .background(AppColors.P2.background)
            .task {
                await viewModel.loadHabits()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    HabitListView()
}
