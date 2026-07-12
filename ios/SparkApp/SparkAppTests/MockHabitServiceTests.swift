//
//  MockHabitServiceTests.swift
//  SparkAppTests
//
//  Unit coverage for MockHabitService — the in-memory HabitService used by
//  previews and tests. Verifies each CRUD operation against the seeded
//  `HabitDataModel.mocks`, per-user read filtering, not-found errors on
//  update/delete, and the shared MockService `showError`/`delay` behaviour.
//
//  Seeded mocks:
//    id 1, userId 1, "Drink Water"  (daily)
//    id 2, userId 1, "Push-ups"     (daily)
//    id 3, userId 2, "Read a Book"  (weekly)
//

import Testing
import Foundation
@testable import SparkApp

@Suite("MockHabitService CRUD")
@MainActor
struct MockHabitServiceTests {

    // MARK: - Create

    @Test("createHabit appends a new habit and returns it with the given fields")
    func createAppendsAndReturns() async throws {
        let sut = MockHabitService()
        let countBefore = sut.habits.count

        let created = try await sut.createHabit(name: "Meditate", frequency: "daily", userId: 7)

        #expect(created.name == "Meditate")
        #expect(created.frequency == "daily")
        #expect(created.userId == 7)
        #expect(created.id == countBefore + 1)
        #expect(sut.habits.count == countBefore + 1)
        #expect(sut.habits.last == created)
    }

    // MARK: - Read (per-user filtering)

    @Test("getHabitsForUser returns only the habits owned by that user")
    func readFiltersByUser() async throws {
        let sut = MockHabitService()

        let user1 = try await sut.getHabitsForUser(userId: 1)
        let user2 = try await sut.getHabitsForUser(userId: 2)

        #expect(user1.count == 2)
        #expect(user1.allSatisfy { $0.userId == 1 })
        #expect(Set(user1.map(\.id)) == [1, 2])

        #expect(user2.count == 1)
        #expect(user2.first?.id == 3)
    }

    @Test("getHabitsForUser returns an empty list for a user with no habits")
    func readUnknownUserIsEmpty() async throws {
        let sut = MockHabitService()

        let habits = try await sut.getHabitsForUser(userId: 999)

        #expect(habits.isEmpty)
    }

    @Test("getHabit returns a habit without throwing")
    func getHabitSucceeds() async throws {
        let sut = MockHabitService()

        let habit = try await sut.getHabit(id: 1, userId: 1)

        #expect(habit == HabitDataModel.mock)
    }

    // MARK: - Update

    @Test("updateHabit mutates the stored habit and returns the updated model")
    func updateMutatesStoredHabit() async throws {
        let sut = MockHabitService()

        let updated = try await sut.updateHabit(id: 2, name: "Squats", frequency: "weekly")

        #expect(updated.id == 2)
        #expect(updated.name == "Squats")
        #expect(updated.frequency == "weekly")

        let stored = sut.habits.first { $0.id == 2 }
        #expect(stored?.name == "Squats")
        #expect(stored?.frequency == "weekly")
    }

    @Test("updateHabit throws when the id does not exist")
    func updateUnknownIdThrows() async throws {
        let sut = MockHabitService()

        await #expect(throws: (any Error).self) {
            try await sut.updateHabit(id: 999, name: "Nope", frequency: "daily")
        }
    }

    // MARK: - Delete

    @Test("deleteHabbit removes the habit from storage")
    func deleteRemovesHabit() async throws {
        let sut = MockHabitService()
        let countBefore = sut.habits.count

        try await sut.deleteHabbit(id: 1)

        #expect(sut.habits.count == countBefore - 1)
        #expect(sut.habits.contains { $0.id == 1 } == false)
        let remaining = try await sut.getHabitsForUser(userId: 1)
        #expect(remaining.map(\.id) == [2])
    }

    @Test("deleteHabbit throws when the id does not exist")
    func deleteUnknownIdThrows() async throws {
        let sut = MockHabitService()
        let countBefore = sut.habits.count

        await #expect(throws: (any Error).self) {
            try await sut.deleteHabbit(id: 999)
        }
        #expect(sut.habits.count == countBefore)
    }

    // MARK: - showError behaviour

    @Test("Every operation throws when showError is set")
    func showErrorThrowsForEveryOperation() async throws {
        let sut = MockHabitService(showError: true)

        await #expect(throws: URLError.self) {
            _ = try await sut.createHabit(name: "X", frequency: "daily", userId: 1)
        }
        await #expect(throws: URLError.self) {
            _ = try await sut.getHabitsForUser(userId: 1)
        }
        await #expect(throws: URLError.self) {
            _ = try await sut.getHabit(id: 1, userId: 1)
        }
        // Uses an existing id so the not-found guard passes and the error path is reached.
        await #expect(throws: URLError.self) {
            _ = try await sut.updateHabit(id: 1, name: "X", frequency: "daily")
        }
        await #expect(throws: URLError.self) {
            try await sut.deleteHabbit(id: 1)
        }
    }

    // MARK: - delay behaviour

    @Test("A configured delay is awaited before the operation completes")
    func delayIsAwaited() async throws {
        let delay: Double = 0.2
        let sut = MockHabitService(delay: delay)

        let clock = ContinuousClock()
        let start = clock.now
        _ = try await sut.getHabitsForUser(userId: 1)
        let elapsed = start.duration(to: clock.now)

        #expect(elapsed >= .seconds(delay))
    }
}
