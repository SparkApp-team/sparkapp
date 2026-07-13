//
//  HabitsView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

struct HabitsListView: View {

    @Environment(DependencyContainer.self) private var container
    @State var viewModel: HabitsListViewModel
    @State private var showAddHabit: Bool = false
    @State private var habitToEdit: HabitDataModel?

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.P2.background
                    .ignoresSafeArea()

                if viewModel.health.status != .good {
                    badServerStatus
                } else {
                    Group {
                        if viewModel.isLoading {
                            loadingHabitsView
                        } else {
                            if viewModel.habits.isEmpty {
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
                addHabitSheet(habit: nil)
                    .habitFormPresentation()
            }
            .sheet(item: $habitToEdit) { habit in
                addHabitSheet(habit: habit)
                    .habitFormPresentation()
            }
            .task {
                await viewModel.checkServerHealth()
                await viewModel.loadHabits()
            }
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
            ForEach(viewModel.habits, id: \.self ) { habit in
                HStack {
                    Text(habit.name)
                        .foregroundColor(AppColors.P2.textPrimary)
                    Spacer()
                }
                .listRowBackground(
                    AppColors.P2.secondaryBackground
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    habitToEdit = habit
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.deleteHabit(habit: habit)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
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
            Task { await viewModel.checkServerHealth() }
        } label: {
            Image(systemName: "checkmark.icloud.fill")
                .font(.title2)
        }
        .tint(viewModel.health.status.color)
    }

    private var addHabitButton: some View {
        Button {
            showAddHabit = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundStyle(.primary)
        }
        .tint(.primary)
    }

    private func addHabitSheet(habit: HabitDataModel?) -> some View {
        AddHabitView(viewModel: AddHabitViewModel(container: container, habit: habit)) {
            Task { await viewModel.loadHabits() }
        }
    }
}

private extension View {
    func habitFormPresentation() -> some View {
        self
            .presentationDetents([.height(260)])
            .presentationBackground(AppColors.P2.background)
            .presentationDragIndicator(.visible)
    }
}

#Preview("Has data") {
    let container = DevPreview.shared.container

    return HabitsListView(viewModel: HabitsListViewModel(container: container))
        .environment(container)
        .previewEnvironment()
}

#Preview("No data") {
    let container = DevPreview.shared.container
    container.register(HabitManager.self, service: HabitManager(service: MockHabitService(habits: [])))

    return HabitsListView(viewModel: HabitsListViewModel(container: container))
        .environment(container)
        .previewEnvironment()
}

#Preview("Bad status") {
    let container = DevPreview.shared.container
    container.register(HealthManager.self, service: HealthManager(service: MockHealthService(health: .badMock)))

    return HabitsListView(viewModel: HabitsListViewModel(container: container))
        .environment(container)
        .previewEnvironment()
}
