//
//  HealthManager.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//

import SwiftUI
import Foundation

@MainActor
@Observable
class HealthManager {
    var service: HealthService

    init(service: HealthService) {
        self.service = service
    }
    
    func getServerHealth() async throws -> ServerHealthDataModel {
        try await service.getServerHealth()
    }
}
