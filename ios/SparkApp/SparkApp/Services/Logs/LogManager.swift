//
//  LogManager.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

import SwiftUI
import Foundation

@MainActor
@Observable
class LogManager {
    private let services: [LogService]

    init(services: [LogService] = []) {
        self.services = services
    }

    func identifyUser(userId: String, name: String?, email: String?) {
        for service in services {
            service.identifyUser(userId: userId, name: name, email: email)
        }
    }

    func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        for service in services {
            service.addUserProperties(dict: dict, isHighPriority: isHighPriority)
        }
    }

    func deleteUserProfile() {
        for service in services {
            service.deleteUserProfile()
        }
    }

    func trackEvent(eventName: String, parameters: [String: Any]? = nil, type: LogType = .analytic) {
        let event = AnyLoggableEvent(eventName: eventName, parameters: parameters, type: type)
        trackEvent(event: event)
    }

    func trackEvent(event: any LoggableEvent) {
        for service in services {
            service.trackEvent(event: event)
        }
    }

    func trackScreenEvent(event: any LoggableEvent) {
        for service in services {
            service.trackScreenEvent(event: event)
        }
    }
}
