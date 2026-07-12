//
//  SparkUserService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

struct SparkUserService: UserService {
    private let client = APIClient()

    func registerUser(email: String, password: String, passwordConfirmation: String) async throws -> UserDataModel {
        let body = try JSONEncoder().encode(RegisterUserRequestBody(email: email, password: password, passwordConfirmation: passwordConfirmation))

        let endpoint = Endpoint(
            path: "auth/register",
            method: .post,
            body: body
        )

        return try await client.send(endpoint)
    }

    func login(email: String, password: String) async throws -> UserDataModel {
        let body = try JSONEncoder().encode(LoginUserRequestBody(email: email, password: password))

        let endpoint = Endpoint(
            path: "auth/login",
            method: .post,
            body: body
        )

        return try await client.send(endpoint)
    }

    func getUser(userId: String) async throws -> UserDataModel {
        let header = ["X-USER-ID": userId]

        let endpoint = Endpoint(
            path: "users/me",
            method: .get,
            headers: header
        )

        return try await client.send(endpoint)
    }
}
