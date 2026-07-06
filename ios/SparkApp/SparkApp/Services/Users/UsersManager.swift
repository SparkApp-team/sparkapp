//
//  UsersManager.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

import SwiftUI
import Foundation

@MainActor
@Observable
class UsersManager {
    var service: UserService
    private let logManager: LogManager?

    init(service: UserService, logManager: LogManager? = nil) {
        self.service = service
        self.logManager = logManager
    }

    func getUser(userId: String) async throws -> UserDataModel {
        logManager?.trackEvent(event: Event.getUserStart)
        do {
            let user = try await service.getUser(userId: userId)
            logManager?.trackEvent(event: Event.getUserSuccess(user: user))
            return user
        } catch {
            logManager?.trackEvent(event: Event.getUserFail(error: error))
            throw error
        }
    }

    func addUser(email: String, password: String) async throws -> UserDataModel {
        logManager?.trackEvent(event: Event.addUserStart)
        do {
            let user = try await service.addUser(email: email, password: password)
            logManager?.trackEvent(event: Event.addUserSuccess(user: user))
            return user
        } catch {
            logManager?.trackEvent(event: Event.addUserFail(error: error))
            throw error
        }
    }
}

extension UsersManager {
    enum Event: LoggableEvent {
        case getUserStart
        case getUserSuccess(user: UserDataModel)
        case getUserFail(error: Error)
        case addUserStart
        case addUserSuccess(user: UserDataModel)
        case addUserFail(error: Error)

        var eventName: String {
            switch self {
            case .getUserStart:   "UsersManager_GetUser_Start"
            case .getUserSuccess: "UsersManager_GetUser_Success"
            case .getUserFail:    "UsersManager_GetUser_Fail"
            case .addUserStart:   "UsersManager_AddUser_Start"
            case .addUserSuccess: "UsersManager_AddUser_Success"
            case .addUserFail:    "UsersManager_AddUser_Fail"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .getUserSuccess(let user), .addUserSuccess(let user):
                user.eventParameters
            case .getUserFail(let error), .addUserFail(let error):
                ["error": error.localizedDescription]
            default:
                nil
            }
        }

        var type: LogType {
            switch self {
            case .getUserFail, .addUserFail: .severe
            default: .analytic
            }
        }
    }
}
