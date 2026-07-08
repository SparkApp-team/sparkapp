//
//  HabitsView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

struct HabitsListView: View {
    
    @Environment(HealthManager.self) private var healthManager
    @Environment(HabitManager.self) private var habitManager
    @Environment(UsersManager.self) private var userManager
    @Environment(LogManager.self) private var logManager

    @State private var health: ServerHealthDataModel = .goodMock
    @State private var habits: [HabitDataModel] = []
    @State private var isLoading: Bool = false
    @State private var showAddHabit: Bool = false
    
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
                    addHabitButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    serverHealthButton
                }
            }
            .devMenuToolbar()
            .sheet(isPresented: $showAddHabit) {
                addHabitSheet
            }
            .task {
                await checkServerHealth()
                await loadHabits()
            }
        }
    }
    
    private func loadHabits() async {
        do {
            guard let userId = userManager.currentUser?.id else {
                logManager.trackEvent(
                    eventName: "HabitsView_LoadHabits_NoUser",
                    type: .warning
                )
                return
            }

            habits = try await habitManager.getHabitsForUser(userId: userId)
        } catch {
            logManager.trackEvent(
                eventName: "HabitsView_LoadHabits_Fail",
                parameters: ["error": error.localizedDescription],
                type: .severe
            )
        }
    }

    private func checkServerHealth() async {
        do {
            health = try await healthManager.getServerHealth()
            logManager.trackEvent(
                eventName: "HabitsView_ServerHealth",
                parameters: ["status": health.status.rawValue],
                type: .info
            )
        } catch {
            health = ServerHealthDataModel(status: .bad)
            logManager.trackEvent(
                eventName: "HabitsView_ServerHealth_Fail",
                parameters: ["error": error.localizedDescription],
                type: .severe
            )
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
                    Text(habit.name)
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

    private var addHabitButton: some View {
        Button {
            showAddHabit = true
        } label: {
            Label("Add Habit", systemImage: "plus")
        }
    }

    private var addHabitSheet: some View {
        AddHabitView {
            Task { await loadHabits() }
        }
    }
}

#Preview("Has data") {
    HabitsListView()
        .previewEnvironment()
}

#Preview("No data") {
    HabitsListView()
        .environment(HabitManager(service: MockHabitService(habits: [])))
        .previewEnvironment()
}

#Preview("Bad status") {
    HabitsListView()
        .environment(HealthManager(service: MockHealthService(health: .badMock)))
        .previewEnvironment()
}
