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
class UserManager {
    var service: UserService
    private let logManager: LogManager?
    var currentUser: UserDataModel? = nil

    init(service: UserService, logManager: LogManager? = nil) {
        self.service = service
        self.logManager = logManager
    }

    func login(email: String, password: String) async throws {
        logManager?.trackEvent(event: Event.loginStart)
        do {
            let user = try await service.login(email: email, password: password)
            persistSession(user)
            logManager?.trackEvent(event: Event.loginSuccess(user: user))
        } catch {
            logManager?.trackEvent(event: Event.loginFail(error: error))
            throw error
        }
    }

    func registerUser(email: String, password: String, passwordConfirmation: String) async throws -> UserDataModel {
        logManager?.trackEvent(event: Event.registerUserStart)
        do {
            let user = try await service.registerUser(email: email, password: password, passwordConfirmation: passwordConfirmation)
            persistSession(user)
            logManager?.trackEvent(event: Event.registerUserSuccess(user: user))
            return user
        } catch {
            logManager?.trackEvent(event: Event.registerUserFail(error: error))
            throw error
        }
    }

    func getUser(id: Int) async throws -> UserDataModel {
        logManager?.trackEvent(event: Event.getUserStart(id: id))
        do {
            let user = try await service.getUser(id: id)
            logManager?.trackEvent(event: Event.getUserSuccess(user: user))
            return user
        } catch {
            logManager?.trackEvent(event: Event.getUserFail(error: error))
            throw error
        }
    }

    @discardableResult
    func restoreSession() async -> Bool {
        logManager?.trackEvent(event: Event.restoreSessionStart)
        guard let userId = UserDefaults.currentUserId else {
            logManager?.trackEvent(event: Event.restoreSessionEmpty)
            return false
        }
        do {
            let user = try await getUser(id: userId)
            currentUser = user
            logManager?.trackEvent(event: Event.restoreSessionSuccess(user: user))
            return true
        } catch {
            logManager?.trackEvent(event: Event.restoreSessionFail(error: error))
            return false
        }
    }

    func logout() {
        logManager?.trackEvent(event: Event.logout)
        currentUser = nil
        UserDefaults.currentUserId = nil
    }

    private func persistSession(_ user: UserDataModel) {
        currentUser = user
        UserDefaults.currentUserId = user.id
        logManager?.trackEvent(event: Event.persistSession(user: user))
    }
}

extension UserManager {
    enum Event: LoggableEvent {
        case loginStart
        case loginSuccess(user: UserDataModel)
        case loginFail(error: Error)
        case registerUserStart
        case registerUserSuccess(user: UserDataModel)
        case registerUserFail(error: Error)
        case getUserStart(id: Int)
        case getUserSuccess(user: UserDataModel)
        case getUserFail(error: Error)
        case restoreSessionStart
        case restoreSessionEmpty
        case restoreSessionSuccess(user: UserDataModel)
        case restoreSessionFail(error: Error)
        case persistSession(user: UserDataModel)
        case logout

        var eventName: String {
            switch self {
            case .loginStart:            "UsersManager_Login_Start"
            case .loginSuccess:          "UsersManager_Login_Success"
            case .loginFail:             "UsersManager_Login_Fail"
            case .registerUserStart:     "UsersManager_RegisterUser_Start"
            case .registerUserSuccess:   "UsersManager_RegisterUser_Success"
            case .registerUserFail:      "UsersManager_RegisterUser_Fail"
            case .getUserStart:          "UsersManager_GetUser_Start"
            case .getUserSuccess:        "UsersManager_GetUser_Success"
            case .getUserFail:           "UsersManager_GetUser_Fail"
            case .restoreSessionStart:   "UsersManager_RestoreSession_Start"
            case .restoreSessionEmpty:   "UsersManager_RestoreSession_Empty"
            case .restoreSessionSuccess: "UsersManager_RestoreSession_Success"
            case .restoreSessionFail:    "UsersManager_RestoreSession_Fail"
            case .persistSession:        "UsersManager_PersistSession"
            case .logout:                "UsersManager_Logout"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .getUserStart(id: let id):
                ["user_id": id]
            case .loginSuccess(let user), .registerUserSuccess(let user),
                 .getUserSuccess(let user), .restoreSessionSuccess(let user),
                 .persistSession(let user):
                user.eventParameters
            case .loginFail(let error), .registerUserFail(let error),
                 .getUserFail(let error), .restoreSessionFail(let error):
                ["error": error.localizedDescription]
            default:
                nil
            }
        }

        var type: LogType {
            switch self {
            case .loginFail, .registerUserFail, .getUserFail, .restoreSessionFail:
                    .severe
            default:
                    .analytic
            }
        }
    }
}

extension UserDefaults {
    private enum Keys {
        static let currentUserId = "currentUserIdKey"
    }

    /// The signed-in user's id, persisted across launches and used like a
    /// session token (sent as the `X-USER-ID` header).
    static var currentUserId: Int? {
        get { standard.integer(forKey: Keys.currentUserId) }
        set { standard.set(newValue, forKey: Keys.currentUserId) }
    }
}
