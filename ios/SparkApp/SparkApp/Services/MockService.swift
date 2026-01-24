//
//  MockService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol MockService {
    var delay: Double { get }
    var showError: Bool { get }
}

extension MockService {
    func executionBehaviour() async throws {
        try? await Task.sleep(for: .seconds(delay))
        
        if showError {
            throw URLError(.unknown)
        }
    }
}
