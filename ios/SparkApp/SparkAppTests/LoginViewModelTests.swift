//
//  LoginViewModelTests.swift
//  SparkAppTests
//
//  Validation coverage for LoginViewModel.onLoginPressed().
//
//  onLoginPressed() runs validation inside a detached Task, so state is updated
//  asynchronously — tests await the outcome via `waitUntil`.
//
//  Validation-failure tests assert the user service is never reached
//  (loginCallCount == 0).
//
//  Note: LoginViewModel only validates that email and password are non-empty.
//  Unlike RegisterViewModel it does NOT check email format, password length,
//  or password confirmation — those cases are documented below as "accepted".
//

import Testing
@testable import SparkApp

@MainActor
private func makeSUT() -> (sut: LoginViewModel, appState: AppState, service: SpyUserService) {
    let logManager = LogManager(services: [])
    let appState = AppState()
    let service = SpyUserService()
    let container = DependencyContainer()
    container.register(AppState.self, service: appState)
    container.register(UserManager.self, service: UserManager(service: service, logManager: logManager))
    container.register(LogManager.self, service: logManager)
    return (LoginViewModel(container: container), appState, service)
}

@MainActor
@Suite("LoginViewModel validation")
struct LoginViewModelTests {

    // MARK: - Valid input

    @Test("Non-empty email and password reach the service")
    func validInput() async {
        let (sut, appState, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "password123"

        sut.onLoginPressed()

        // Validation passes and login succeeds → app moves to content.
        #expect(await waitUntil { appState.option == .content })
        #expect(sut.errorMessage == nil)
        #expect(service.loginCallCount == 1)
    }

    // MARK: - Empty / whitespace fields

    @Test("Empty email is rejected without calling the service")
    func emptyEmail() async {
        let (sut, _, service) = makeSUT()
        sut.email = ""
        sut.password = "password123"

        sut.onLoginPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Email is empty.")
        #expect(service.loginCallCount == 0)
    }

    @Test("Whitespace-only email is treated as empty and skips the service")
    func whitespaceEmail() async {
        let (sut, _, service) = makeSUT()
        sut.email = "   "
        sut.password = "password123"

        sut.onLoginPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Email is empty.")
        #expect(service.loginCallCount == 0)
    }

    @Test("Empty password is rejected without calling the service")
    func emptyPassword() async {
        let (sut, _, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = ""

        sut.onLoginPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Password is empty.")
        #expect(service.loginCallCount == 0)
    }

    @Test("Whitespace-only password is treated as empty and skips the service")
    func whitespacePassword() async {
        let (sut, _, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "        "

        sut.onLoginPressed()

        #expect(await waitUntil { sut.errorMessage != nil })
        #expect(sut.errorMessage == "Password is empty.")
        #expect(service.loginCallCount == 0)
    }

    // MARK: - Cases Login intentionally does NOT validate

    @Test("Malformed email is accepted at login (no format check)")
    func invalidEmailFormatIsAccepted() async {
        let (sut, appState, service) = makeSUT()
        sut.email = "not-an-email"
        sut.password = "password123"

        sut.onLoginPressed()

        // Login performs no format validation, so this passes and succeeds.
        #expect(await waitUntil { appState.option == .content })
        #expect(sut.errorMessage == nil)
        #expect(service.loginCallCount == 1)
    }

    @Test("Short password is accepted at login (no length check)")
    func shortPasswordIsAccepted() async {
        let (sut, appState, service) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "short"

        sut.onLoginPressed()

        // Login performs no length validation, so this passes and succeeds.
        #expect(await waitUntil { appState.option == .content })
        #expect(sut.errorMessage == nil)
        #expect(service.loginCallCount == 1)
    }
}
