//
//  MockSparkService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

struct MockSparkService: SparkService, MockService {
    var status: ServerStatus
    var delay: Double
    var showError: Bool
    
    init(status: ServerStatus = .goodMock, delay: Double = 0.0, showError: Bool = false) {
        self.status = status
        self.delay = delay
        self.showError = showError
    }
    
    func getServerStatus() async throws -> ServerStatus {
        try await executionBehaviour()
        return status
    }
}
