//
//  SparkServerService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

struct SparkServerService: SparkService {
    private let baseURL: URL
    private let session: URLSession = .shared

    init(environment: APIEnvironment = .current) {
        self.baseURL = environment.baseURL
    }

    func getServerStatus() async throws -> ServerStatus {
        let url = baseURL.appendingPathComponent("health")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")

        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        do {
            let serverStatus = try JSONDecoder().decode(ServerStatus.self, from: data)
            return serverStatus
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
