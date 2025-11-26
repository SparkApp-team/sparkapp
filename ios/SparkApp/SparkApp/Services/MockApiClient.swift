//
//  MockApiClient.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import Foundation

final class MockApiClient {
    static let shared = MockApiClient()
    private init() {}
    
    //private let baseURL
    
    func getHabits() async throws -> [Habit] {
        try await Task.sleep(for: .seconds(0.8))
        
        return [
            Habit(id: "1", name: "Push Ups", type: .counter, createdAt: Date(), updatedAt: Date()),
            Habit(id: "2", name: "Squating", type: .counter, createdAt: Date(), updatedAt: Date()),
            Habit(id: "3", name: "Clean room", type: .boolean, createdAt: Date(), updatedAt: Date())
        ]
    }
}
