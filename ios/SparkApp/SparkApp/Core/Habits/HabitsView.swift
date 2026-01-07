//
//  HabitsView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

struct HabitsView: View {
    
    @State private var habits: [HabitModel] = HabitModel.mocks //[]
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.P2.background
                    .ignoresSafeArea()
                
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
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    serverStatusButton
                }
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
    
    private var serverStatusButton: some View {
        Button {
            // action
        } label: {
            Label("Status", systemImage: "checkmark.icloud.fill")
        }
    }
}

#Preview {
    HabitsView()
}
