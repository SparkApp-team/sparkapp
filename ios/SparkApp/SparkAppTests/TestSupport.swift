//
//  TestSupport.swift
//  SparkAppTests
//
//  Shared helpers for ViewModel tests.
//
//  The auth ViewModels run validation inside a detached `Task`, so `errorMessage`
//  (and other state) is updated asynchronously. Tests poll for the expected state
//  with `waitUntil` rather than reading it synchronously.
//

import Foundation
@testable import SparkApp

@MainActor
@discardableResult
func waitUntil(
    timeout: Duration = .seconds(2),
    _ condition: () -> Bool
) async -> Bool {
    let clock = ContinuousClock()
    let deadline = clock.now.advanced(by: timeout)
    while clock.now < deadline {
        if condition() { return true }
        try? await Task.sleep(for: .milliseconds(5))
    }
    return condition()
}

// MARK: - Spy services

/// Records how many times each endpoint is called so tests can assert that the
/// service is (or isn't) reached — e.g. skipped when client validation fails.
@MainActor
final class SpyUserService: UserService {
    private(set) var registerCallCount = 0
    private(set) var loginCallCount = 0
    private(set) var getUserCallCount = 0
    var user: UserDataModel = .mock

    func registerUser(email: String, password: String) async throws -> UserDataModel {
        registerCallCount += 1
        return UserDataModel(id: "spy", email: email)
    }

    func login(email: String, password: String) async throws -> UserDataModel {
        loginCallCount += 1
        return user
    }

    func getUser(userId: String) async throws -> UserDataModel {
        getUserCallCount += 1
        return user
    }
}

@MainActor
final class SpyHabitService: HabitService {
    private(set) var createCallCount = 0
    private(set) var getHabitsCallCount = 0

    func createHabit(name: String, frequency: String, userId: String) async throws -> HabitDataModel {
        createCallCount += 1
        return .mock
    }

    func getHabitsForUser(userId: String) async throws -> [HabitDataModel] {
        getHabitsCallCount += 1
        return HabitDataModel.mocks
    }
}
