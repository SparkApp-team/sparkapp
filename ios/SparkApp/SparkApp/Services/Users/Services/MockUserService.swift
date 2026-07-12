//
//  MockUserService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

struct MockUserService: UserService, MockService {
    var user: UserDataModel
    var delay: Double
    var showError: Bool

    init(user: UserDataModel = .mock, delay: Double = 0.0, showError: Bool = false) {
        self.user = user
        self.delay = delay
        self.showError = showError
    }

    func registerUser(email: String, password: String, passwordConfirmation: String) async throws -> UserDataModel {
        try await executionBehaviour()
        let newUser = UserDataModel(id: UUID().uuidString, email: email)
        return newUser
    }

    func login(email: String, password: String) async throws -> UserDataModel {
        try await executionBehaviour()
        return user
    }

    func getUser(userId: String) async throws -> UserDataModel {
        try await executionBehaviour()
        return user
    }
}
