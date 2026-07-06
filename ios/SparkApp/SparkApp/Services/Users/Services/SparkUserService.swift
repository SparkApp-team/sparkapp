//
//  SparkUserService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

struct SparkUserService: UserService {
    private let baseURL: URL
    private let session: URLSession = .shared

    init(environment: APIEnvironment = .current) {
        self.baseURL = environment.baseURL
    }

    func addUser(email: String, password: String) async throws -> UserDataModel {
        let url = baseURL
            .appendingPathComponent("users")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        request.setValue(UUID().hashValue.description, forHTTPHeaderField: "X-USER-ID")
        request.httpBody = try JSONEncoder().encode(
            CreateUserRequest(email: email, password: password)
        )

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        do {
            let user = try JSONDecoder().decode(UserDataModel.self, from: data)
            return user
        } catch {
            // Surface the underlying DecodingError instead of masking it.
            throw error
        }
    }

    func getUser(userId: String) async throws -> UserDataModel {
        let url = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("me")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        request.setValue(userId, forHTTPHeaderField: "X-USER-ID")

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        do {
            let user = try JSONDecoder().decode(UserDataModel.self, from: data)
            return user
        } catch {
            // Surface the underlying DecodingError instead of masking it.
            throw error
        }
    }
}
