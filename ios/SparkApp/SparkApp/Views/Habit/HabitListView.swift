//
//  HabitListView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

//Fix:
//1. normal loading animation + background
//2. think about secondary background color
//3. border for list

struct HabitListView: View {
    @StateObject private var viewModel = HabitViewModel()
    
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
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.habits) { habit in
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
            }
            .navigationTitle("Habits")
            .background(AppColors.P2.background)
            .task {
                await viewModel.loadHabits()
                await viewModel.getStatus(showAlert: false)
            }
            .refreshable {
                await viewModel.refresh()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.getStatus() }
                    } label: {
                        Label("Status", systemImage: "checkmark.icloud.fill")
                    }
                    .tint(viewModel.status?.color)
                }
            }
            .alert("Server Status", isPresented: $viewModel.showStatusAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.status?.status ?? viewModel.errorMessage ?? "Unknown")
            }
        }
    }
}

#Preview {
    HabitListView()
}
