//
//  MockHealthService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

struct MockHealthService: HealthService, MockService {
    var health: ServerHealthDataModel
    var delay: Double
    var showError: Bool
    
    init(health: ServerHealthDataModel = .goodMock, delay: Double = 0.0, showError: Bool = false) {
        self.health = health
        self.delay = delay
        self.showError = showError
    }
    
    func getServerHealth() async throws -> ServerHealthDataModel {
        try await executionBehaviour()
        return health
    }
}
