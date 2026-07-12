//
//  SparkHabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

struct SparkHabitService: HabitService {    
    private let client = APIClient()
    
    func createHabit(name: String, frequency: String, userId: Int) async throws -> HabitDataModel {
        let header = ["X-USER-ID": String(userId)]
        let body = try JSONEncoder().encode(HabitCreateRequestBody(name: name, frequency: frequency))

        let endpoint = Endpoint(
            path: "habits",
            method: .post,
            headers: header,
            body: body
        )

        return try await client.send(endpoint)
    }
    
    // MOCK
    func deleteHabbit(id: Int) async throws {
        throw NSError(
            domain: "Not ready",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Enpoint is not ready."]
        )
    }
    
    // MOCK
    func updateHabit(id: Int, name: String, frequency: String) async throws -> HabitDataModel {
        throw NSError(
            domain: "Not ready",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Enpoint is not ready."]
        )
    }
    
    // MOCK
    func getHabit(id: Int, userId: Int) async throws -> HabitDataModel {
        throw NSError(
            domain: "Not ready",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Enpoint is not ready."]
        )
    }
    
    func getHabitsForUser(userId: Int) async throws -> [HabitDataModel] {
        let header = ["X-USER-ID": String(userId)]

        let endpoint = Endpoint(
            path: "habits",
            method: .get,
            headers: header
        )

        return try await client.send(endpoint)
    }
}
