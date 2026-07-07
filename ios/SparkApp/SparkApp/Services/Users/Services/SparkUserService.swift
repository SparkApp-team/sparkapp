//
//  SparkUserService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

protocol StatusMappedError: Error {
    var statusCode: Int { get }
}

enum UserServiceError: StatusMappedError {
    case unauthorized
    case unknown
    case conflict
    case badRequest
    case internalServerError

    var statusCode: Int {
        switch self {
        case .internalServerError:           500
        case .conflict:                      409
        case .badRequest:                    400
        case .unauthorized:                  401
        case .unknown:                       -1   // never matches a real status
        }
    }
}

struct SparkUserService: UserService {
    private let client = APIClient()

    func registerUser(email: String, password: String) async throws -> UserDataModel {
        let body = try JSONEncoder().encode(AuthUserRequestBody(email: email, password: password))

        let endpoint = Endpoint(
            path: "auth/register",
            method: .post,
            body: body
        )

        return try await client.send(endpoint, statusErrors: [UserServiceError.conflict,
                                                              UserServiceError.badRequest])
    }

    func login(email: String, password: String) async throws -> UserDataModel {
        let body = try JSONEncoder().encode(AuthUserRequestBody(email: email, password: password))

        let endpoint = Endpoint(
            path: "auth/login",
            method: .post,
            body: body
        )

        return try await client.send(endpoint, statusErrors: [UserServiceError.unauthorized,
                                                              UserServiceError.badRequest])
    }

    func getUser(userId: String) async throws -> UserDataModel {
        let header = ["X-USER-ID": userId]

        let endpoint = Endpoint(
            path: "users/me",
            method: .get,
            headers: header
        )

        return try await client.send(endpoint, statusErrors: [UserServiceError.internalServerError,
                                                              UserServiceError.badRequest])
    }
}
