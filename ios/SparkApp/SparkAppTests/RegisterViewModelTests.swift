//
//  RegisterViewModelTests.swift
//  SparkAppTests
//
//  Validation coverage for RegisterViewModel.onRegisterPressed().
//
//  onRegisterPressed() runs validation inside a detached Task, so state is
//  updated asynchronously — tests await the outcome via `waitUntil`.
//
//  Every validation-failure test also asserts the user service is never reached
//  (registerCallCount == 0): client validation must short-circuit the request.
//

import Testing
@testable import SparkApp

@MainActor
private func makeSUT() -> (sut: RegisterViewModel, appState: AppState, service: SpyUserService) {
    let logManager = LogManager(services: [])
    let appState = AppState()
    let service = SpyUserService()
    let container = DependencyContainer()
    container.register(AppState.self, service: appState)
    container.register(UserManager.self, service: UserManager(service: service, logManager: logManager))
    container.register(LogManager.self, service: logManager)
    return (RegisterViewModel(container: container), appState, service)
}

@MainActor
@Suite("RegisterViewModel validation")
struct RegisterViewModelTests {

    // MARK: - Valid input

    @Test("Valid email and matching passwords reach the service")
    func validInput() async {
        let (sut, appState, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"

        sut.onRegisterPressed()

        // Validation passes and registration succeeds → app moves to content.
        #expect(await waitUntil { appState.option == .content })
        #expect(sut.errorMessage == nil)
        #expect(service.registerCallCount == 1)
    }

    // MARK: - Empty / whitespace fields

    @Test("Empty email is rejected without calling the service")
    func emptyEmail() async {
        let (sut, _, service) = makeSUT()
        sut.email = ""
        sut.password = "password123"
        sut.confirmPassword = "password123"

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Email is empty.")
        #expect(service.registerCallCount == 0)
    }

    @Test("Whitespace-only email is treated as empty and skips the service")
    func whitespaceEmail() async {
        let (sut, _, service) = makeSUT()
        sut.email = "    "
        sut.password = "password123"
        sut.confirmPassword = "password123"

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Email is empty.")
        #expect(service.registerCallCount == 0)
    }

    @Test("Empty password is rejected without calling the service")
    func emptyPassword() async {
        let (sut, _, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = ""
        sut.confirmPassword = ""

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Password is empty.")
        #expect(service.registerCallCount == 0)
    }

    @Test("Whitespace-only password is treated as empty and skips the service")
    func whitespacePassword() async {
        let (sut, _, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "        "
        sut.confirmPassword = "        "

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Password is empty.")
        #expect(service.registerCallCount == 0)
    }

    // MARK: - Invalid email format

    @Test("Malformed email is rejected without calling the service", arguments: [
        "not-an-email",
        "missing@domain",
        "@example.com",
        "user@.com",
        "user example@test.com"
    ])
    func invalidEmailFormat(_ email: String) async {
        let (sut, _, service) = makeSUT()
        sut.email = email
        sut.password = "password123"
        sut.confirmPassword = "password123"

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Invalid email format.")
        #expect(service.registerCallCount == 0)
    }

    @Test("Disallowed email domain is rejected without calling the service")
    func disallowedDomain() async {
        let (sut, _, service) = makeSUT()
        sut.email = "user@yandex.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Email domain is not allowed.")
        #expect(service.registerCallCount == 0)
    }

    // MARK: - Short password

    @Test("Password shorter than 8 characters is rejected without calling the service")
    func shortPassword() async {
        let (sut, _, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "short"
        sut.confirmPassword = "short"

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Password must be at least 8 characters long.")
        #expect(service.registerCallCount == 0)
    }

    // MARK: - Mismatched passwords

    @Test("Non-matching passwords are rejected without calling the service")
    func mismatchedPasswords() async {
        let (sut, _, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password456"

        sut.onRegisterPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Passwords don't match.")
        #expect(service.registerCallCount == 0)
    }
}
