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

    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        do {
            // Build URL
            guard var components = URLComponents(
                url: environment.baseURL, resolvingAgainstBaseURL: false
            ) else { throw APIError.invalidURL }

            components.path += endpoint.path.hasPrefix("/") ? endpoint.path : "/" + endpoint.path
            if !endpoint.queryItems.isEmpty { components.queryItems = endpoint.queryItems }
            guard let url = components.url else { throw APIError.invalidURL }

            // Build request
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")

            for (key, value) in endpoint.headers {
                request.setValue(String(value), forHTTPHeaderField: key)
            }

            if endpoint.body != nil  {
                request.httpBody = endpoint.body
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            // Send request + Decode response
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let serverMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data).message
                throw APIError.badResponse(statusCode: statusCode, message: serverMessage, data: data)
            }

            return try JSONDecoder().decode(Response.self, from: data)
        } catch APIError.badResponse(let statusCode, let message, let data) {
            throw APIError.badResponse(statusCode: statusCode, message: message, data: data)
        }
    }
}
