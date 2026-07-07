//
//  HealthService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol HealthService: Sendable {
    func getServerHealth() async throws -> ServerHealthDataModel
}
