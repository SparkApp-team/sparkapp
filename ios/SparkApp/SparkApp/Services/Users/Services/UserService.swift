//
//  UserService.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 24.01.2026.
//

import SwiftUI

protocol UserService: Sendable {
    func registerUser(email: String, password: String, passwordConfirmation: String) async throws -> UserDataModel
    func login(email: String, password: String) async throws -> UserDataModel
    func getUser(userId: String) async throws -> UserDataModel
}
