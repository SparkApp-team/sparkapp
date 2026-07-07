//
//  HabitsView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

struct HabitsView: View {
    
    @Environment(HealthManager.self) private var healthManager
    @Environment(HabitManager.self) private var habitManager
    
    @State private var health: ServerHealthDataModel = .goodMock
    @State private var habits: [HabitDataModel] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.P2.background
                    .ignoresSafeArea()
                
                if health.status != .good {
                    badServerStatus
                } else {
                    Group {
                        if isLoading {
                            loadingHabitsView
                        } else {
                            if habits.isEmpty {
                                emptyHabitsView
                            } else {
                                habitsView
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    serverHealthButton
                }
            }
            .task {
                await checkServerHealth()
                await loadHabits()
            }
        }
    }
    
    private func loadHabits() async {
        do {
            habits = try await habitManager.getHabitsForUser(userId: "")
        } catch {
            print("Error loading habits: \(error)")
        }
    }
    
    private func checkServerHealth() async {
        do {
            health = try await healthManager.getServerHealth()
            print("Server status is: \(health.status.rawValue)")
        } catch {
            health = ServerHealthDataModel(status: .bad)
            print("Error checking server status: \(error)")
        }
    }
    
    private var loadingHabitsView: some View {
        VStack {
            ProgressView()
            Text("Loading habits...")
                .foregroundStyle(AppColors.P2.textPrimary)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var habitsView: some View {
        List {
            ForEach(habits, id: \.self ) { habit in
                HStack {
                    Text(habit.name ?? "")
                        .foregroundColor(AppColors.P2.textPrimary)
                    Spacer()
                }
                .listRowBackground(
                    AppColors.P2.secondaryBackground
                )
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.insetGrouped)
    }
    
    private var emptyHabitsView: some View {
        Text("Your habits will appear here!")
            .foregroundStyle(AppColors.P2.textSecondary)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(40)
    }
    
    private var badServerStatus: some View {
        Text("Could not connect. Check your internet connection or try again later.")
            .foregroundStyle(AppColors.P2.textSecondary)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(40)
    }
    
    private var serverHealthButton: some View {
        Button {
            Task { await checkServerHealth() }
        } label: {
            Label("Health", systemImage: "checkmark.icloud.fill")
        }
        .tint(health.status.color)
    }
}

#Preview("Has data") {
    HabitsView()
        .previewEnvironment()
}

#Preview("No data") {
    HabitsView()
        .environment(HabitManager(service: MockHabitService(habits: [])))
        .previewEnvironment()
}

#Preview("Bad status") {
    HabitsView()
        .environment(HealthManager(service: MockHealthService(health: .badMock)))
        .previewEnvironment()
}
