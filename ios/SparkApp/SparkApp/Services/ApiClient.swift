//
//  ApiClient.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//


import Foundation

final class ApiClient {
    static let shared = ApiClient()
    private init() {}
    
    private let baseURL = URL(string: "http://localhost:8080")!
    private let session: URLSession = .shared
    
    //Status
    func getStatus() async throws -> String {
        let url = baseURL.appendingPathComponent("health")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // ******* plain text
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return responseString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //return try JSONDecoder().decode(String.self, from: data)
    }
}
