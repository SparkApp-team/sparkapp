//
//  SparkManager.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//

import SwiftUI
import Foundation

@MainActor
@Observable
class SparkManager {
    var service: SparkService
    
    init(service: SparkService) {
        self.service = service
    }
    
    func getServerStatus() async throws -> ServerStatus {
        try await service.getServerStatus()
    }
}
