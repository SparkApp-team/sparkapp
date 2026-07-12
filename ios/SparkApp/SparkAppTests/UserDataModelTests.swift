//
//  UserDataModelTests.swift
//  SparkAppTests
//
//  Verifies UserDataModel Codable behavior after `id` became an Int keyed by
//  "id" (previously a String keyed by "userId").
//

import Foundation
import Testing
@testable import SparkApp

@MainActor
struct UserDataModelTests {

    @Test func decodesIdFromIntKey() throws {
        let json = Data(#"{"id": 42, "email": "user@example.com"}"#.utf8)

        let model = try JSONDecoder().decode(UserDataModel.self, from: json)

        #expect(model.id == 42)
        #expect(model.email == "user@example.com")
    }

    @Test func failsToDecodeWhenIdIsMissing() {
        let json = Data(#"{"userId": 42, "email": "user@example.com"}"#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(UserDataModel.self, from: json)
        }
    }

    @Test func failsToDecodeWhenIdIsString() {
        let json = Data(#"{"id": "42", "email": "user@example.com"}"#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(UserDataModel.self, from: json)
        }
    }

    @Test func encodesIdUnderIdKey() throws {
        let model = UserDataModel(id: 7, email: "user@example.com")

        let data = try JSONEncoder().encode(model)
        let object = try #require(
            try JSONSerialization.jsonObject(with: data) as? [String: Any]
        )

        #expect(object["id"] as? Int == 7)
        #expect(object["userId"] == nil)
        #expect(object["email"] as? String == "user@example.com")
    }

    @Test func roundTripsThroughCodable() throws {
        let original = UserDataModel(id: 3, email: "round@trip.com")

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(UserDataModel.self, from: data)

        #expect(decoded == original)
    }
}
