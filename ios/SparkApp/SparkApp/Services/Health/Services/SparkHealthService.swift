//
//  SparkHealthService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

struct SparkHealthService: HealthService {
    private let client = APIClient()

    func getServerHealth() async throws -> ServerHealthDataModel {
        try await client.send(Endpoint(path: "health"))
    }
}
