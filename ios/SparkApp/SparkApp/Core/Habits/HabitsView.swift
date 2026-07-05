//
//  HabitsView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

struct HabitsView: View {
    
    @Environment(SparkManager.self) private var sparkManager
    @Environment(HabitManager.self) private var habitManager
    
    @State private var status: ServerStatus = .goodMock
    @State private var habits: [HabitDataModel] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.P2.background
                    .ignoresSafeArea()
                
                if status != .ok {
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
                    serverStatusButton
                }
            }
            .task {
                await checkServerStatus()
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
    
    private func checkServerStatus() async {
        do {
            status = try await sparkManager.getServerStatus()
            print("Server status is: \(status)")
        } catch {
            status = .bad
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
    
    private var serverStatusButton: some View {
        Button {
            Task { await checkServerStatus() }
        } label: {
            Label("Status", systemImage: "checkmark.icloud.fill")
        }
        .tint(status.color)
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
        .environment(SparkManager(service: MockSparkService(status: .badMock)))
        .previewEnvironment()
}
