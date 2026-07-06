//
//  CreateUserRequest.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

struct CreateUserRequest: Encodable {
    let email: String
    let password: String
}
