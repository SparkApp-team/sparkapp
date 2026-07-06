//
//  _LogService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

protocol LogService {
    func identifyUser(userId: String, name: String?, email: String?)
    func addUserProperties(dict: [String: Any], isHighPriority: Bool)
    func deleteUserProfile()
    func trackEvent(event: any LoggableEvent)
    func trackScreenEvent(event: any LoggableEvent)
}
