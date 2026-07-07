//
//  ConsoleService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

import Foundation
import OSLog

nonisolated enum LogType {
    case info       // 👋 dev-only noise
    case analytic   // 📈 product analytics
    case warning    // ⚠️ recoverable problem
    case severe     // 🚨 crash / non-fatal error

    var emoji: String {
        switch self {
        case .info: "👋"
        case .analytic: "📈"
        case .warning: "⚠️"
        case .severe: "🚨"
        }
    }

    var asOSLogType: OSLogType {
        switch self {
        case .info: .info
        case .analytic: .default
        case .warning: .error
        case .severe: .fault
        }
    }
}

actor LogSystem {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "SparkApp",
        category: "logs"
    )

    func log(level: LogType, message: String) {
        logger.log(level: level.asOSLogType, "\(message, privacy: .public)")
    }
}

struct ConsoleService: LogService {
    private let logger = LogSystem()
    private let printParameters: Bool

    init(printParameters: Bool = true) {
        self.printParameters = printParameters
    }

    func identifyUser(userId: String, name: String?, email: String?) {
        var message = "🆔 Identify User: \(userId)"
        if printParameters {
            if let name { message += "\n  name: \(name)" }
            if let email { message += "\n  email: \(email)" }
        }
        log(level: .info, message: message)
    }

    func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        var message = "🏷️ Add User Properties (highPriority: \(isHighPriority))"
        if printParameters {
            message += string(for: dict)
        }
        log(level: .info, message: message)
    }

    func deleteUserProfile() {
        log(level: .info, message: "🗑️ Delete User Profile")
    }

    func trackEvent(event: any LoggableEvent) {
        var message = "\(event.type.emoji) \(event.eventName)"
        if printParameters, let parameters = event.parameters {
            message += string(for: parameters)
        }
        log(level: event.type, message: message)
    }

    func trackScreenEvent(event: any LoggableEvent) {
        trackEvent(event: event)
    }

    // MARK: - Helpers

    private func log(level: LogType, message: String) {
        Task {
            await logger.log(level: level, message: message)
        }
    }

    private func string(for parameters: [String: Any]) -> String {
        parameters.keys.sorted().reduce(into: "") { result, key in
            if let value = parameters[key] {
                result += "\n  (key: \"\(key)\", value: \(value))"
            }
        }
    }
}
