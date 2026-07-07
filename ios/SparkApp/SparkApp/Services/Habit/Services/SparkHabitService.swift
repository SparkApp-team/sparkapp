//
//  SparkHabitService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import Foundation

struct SparkHabitService: HabitService {
    private let client = APIClient()
    
    func createHabit(name: String, frequency: String, userId: String) async throws -> HabitDataModel {
        let header = ["X-USER-ID": userId]
        let body = try JSONEncoder().encode(HabitCreateRequestBody(name: name, frequency: frequency))

        let endpoint = Endpoint(
            path: "habits",
            method: .post,
            headers: header,
            body: body
        )

        return try await client.send(endpoint)
    }
    
    func getHabitsForUser(userId: String) async throws -> [HabitDataModel] {
        let header = ["X-USER-ID": userId]

        let endpoint = Endpoint(
            path: "habits",
            method: .get,
            headers: header
        )

        return try await client.send(endpoint)
    }
}
