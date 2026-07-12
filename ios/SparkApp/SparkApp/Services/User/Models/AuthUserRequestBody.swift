//
//  AuthUserRequestBody.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

struct LoginUserRequestBody: Encodable {
    let email: String
    let password: String
}

struct RegisterUserRequestBody: Encodable {
    let email: String
    let password: String
    let passwordConfirmation: String
}
