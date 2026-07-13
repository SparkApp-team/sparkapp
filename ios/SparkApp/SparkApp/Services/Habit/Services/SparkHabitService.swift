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
    
    func deleteHabbit(id: Int, userId: Int) async throws {
        let header = ["X-USER-ID": String(userId)]

        let endpoint = Endpoint(
            path: "habits/\(id)",
            method: .delete,
            headers: header
        )

        try await client.send(endpoint)
    }
    
    func updateHabit(id: Int, userId: Int, name: String, frequency: String) async throws -> HabitDataModel {
        let header = ["X-USER-ID": String(userId)]

        let endpoint = Endpoint(
            path: "habits/\(id)",
            method: .put,
            headers: header
        )

        return try await client.send(endpoint)
    }
    
    func getHabit(id: Int, userId: Int) async throws -> HabitDataModel {
        let header = ["X-USER-ID": String(userId)]

        let endpoint = Endpoint(
            path: "habits/\(id)",
            method: .get,
            headers: header
        )

        return try await client.send(endpoint)
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
