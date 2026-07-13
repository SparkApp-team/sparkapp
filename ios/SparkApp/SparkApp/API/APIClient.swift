//
//  APIClient.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.07.2026.
//

import Foundation

struct APIClient {
    var environment: APIEnvironment = .current
    var session: URLSession = .shared

    private func perform(_ endpoint: Endpoint) async throws -> Data {
        guard var components = URLComponents(
            url: environment.baseURL, resolvingAgainstBaseURL: false
        ) else { throw APIError.invalidURL }
        
        components.path += endpoint.path.hasPrefix("/") ? endpoint.path : "/" + endpoint.path
        if !endpoint.queryItems.isEmpty { components.queryItems = endpoint.queryItems }
        guard let url = components.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if endpoint.body != nil {
            request.httpBody = endpoint.body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let serverMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data).message
            throw APIError.badResponse(statusCode: statusCode, message: serverMessage, data: data)
        }
        return data
    }

    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        let data = try await perform(endpoint)
        return try JSONDecoder().decode(Response.self, from: data)
    }

    func send(_ endpoint: Endpoint) async throws {
        _ = try await perform(endpoint)
    }
}
