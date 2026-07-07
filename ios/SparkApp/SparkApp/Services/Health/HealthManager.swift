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
    private let logManager: LogManager?

    init(service: HealthService, logManager: LogManager? = nil) {
        self.service = service
        self.logManager = logManager
    }

    func getServerHealth() async throws -> ServerHealthDataModel {
        logManager?.trackEvent(event: Event.getServerHealthStart)
        do {
            let health = try await service.getServerHealth()
            logManager?.trackEvent(event: Event.getServerHealthSuccess(health: health))
            return health
        } catch {
            logManager?.trackEvent(event: Event.getServerHealthFail(error: error))
            throw error
        }
    }
}

extension HealthManager {
    enum Event: LoggableEvent {
        case getServerHealthStart
        case getServerHealthSuccess(health: ServerHealthDataModel)
        case getServerHealthFail(error: Error)

        var eventName: String {
            switch self {
            case .getServerHealthStart:   "HealthManager_GetServerHealth_Start"
            case .getServerHealthSuccess: "HealthManager_GetServerHealth_Success"
            case .getServerHealthFail:    "HealthManager_GetServerHealth_Fail"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .getServerHealthSuccess(let health):
                health.eventParameters
            case .getServerHealthFail(let error):
                ["error": error.localizedDescription]
            default:
                nil
            }
        }

        var type: LogType {
            switch self {
            case .getServerHealthFail: .severe
            default:                   .analytic
            }
        }
    }
}
