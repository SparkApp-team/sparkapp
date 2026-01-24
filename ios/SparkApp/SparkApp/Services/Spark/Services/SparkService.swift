//
//  SparkService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol SparkService: Sendable {
    func getServerStatus() async throws -> ServerStatus
}
