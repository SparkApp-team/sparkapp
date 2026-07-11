//
//  AddHabitViewModelTests.swift
//  SparkAppTests
//
//  Validation coverage for AddHabitViewModel.
//
//  AddHabitViewModel has no email/password fields, so the email-format,
//  password-length, and password-match cases do not apply. Its validation
//  surface is:
//    - `canSave`: name must be non-empty after trimming (the View gates the
//      Save button on this, so an empty name never reaches `save`).
//    - the signed-in-user guard inside `save(onSuccess:)`, which short-circuits
//      before the habit service is called.
//

import Testing
@testable import SparkApp

@MainActor
private func makeSUT() -> (sut: AddHabitViewModel, userManager: UserManager, habitService: SpyHabitService) {
    let logManager = LogManager(services: [])
    let habitService = SpyHabitService()
    let userManager = UserManager(service: SpyUserService(), logManager: logManager)
    let container = DependencyContainer()
    container.register(HabitManager.self, service: HabitManager(service: habitService, logManager: logManager))
    container.register(UserManager.self, service: userManager)
    container.register(LogManager.self, service: logManager)
    return (AddHabitViewModel(container: container), userManager, habitService)
}

@MainActor
@Suite("AddHabitViewModel validation")
struct AddHabitViewModelTests {

    // MARK: - canSave (name validity)

    @Test("Non-empty name can be saved")
    func validName() {
        let (sut, _, _) = makeSUT()
        sut.name = "Drink water"

        #expect(sut.canSave == true)
    }

    @Test("Name surrounded by whitespace is still valid")
    func paddedNameIsValid() {
        let (sut, _, _) = makeSUT()
        sut.name = "  Read a book  "

        #expect(sut.canSave == true)
    }

    @Test("Empty name cannot be saved")
    func emptyName() {
        let (sut, _, _) = makeSUT()
        sut.name = ""

        #expect(sut.canSave == false)
    }

    @Test("Whitespace-only name cannot be saved")
    func whitespaceName() {
        let (sut, _, _) = makeSUT()
        sut.name = "     "

        #expect(sut.canSave == false)
    }

    // MARK: - Signed-in user guard

    @Test("Saving without a signed-in user reports an error and skips the service")
    func saveWithoutSignedInUser() {
        let (sut, userManager, habitService) = makeSUT()
        #expect(userManager.currentUser == nil)

        sut.name = "Drink water"

        var didSucceed = false
        sut.save(onSuccess: { didSucceed = true })

        #expect(sut.errorMessage == "No signed-in user.")
        #expect(didSucceed == false)
        #expect(habitService.createCallCount == 0)
    }

    // MARK: - Successful save

    @Test("Saving a valid habit while signed in reaches the service")
    func saveWithSignedInUser() async throws {
        let (sut, userManager, habitService) = makeSUT()
        try await userManager.login(email: "test@example.com", password: "password123")
        #expect(userManager.currentUser != nil)

        sut.name = "Drink water"

        var didSucceed = false
        sut.save(onSuccess: { didSucceed = true })

        #expect(await waitUntil { didSucceed })
        #expect(sut.errorMessage == nil)
        #expect(habitService.createCallCount == 1)
    }
}
