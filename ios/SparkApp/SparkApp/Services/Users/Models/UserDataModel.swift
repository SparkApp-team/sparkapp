//
//  UserDataModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

struct UserDataModel: Hashable, Codable {
    let id: String
    let email: String

    init(
        id: String,
        email: String
    ) {
        self.id = id
        self.email = email
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Backend serializes `id` as a numeric Long; accept a number or a string.
        if let numericId = try? container.decode(Int.self, forKey: .id) {
            self.id = String(numericId)
        } else {
            self.id = try container.decode(String.self, forKey: .id)
        }
        self.email = try container.decode(String.self, forKey: .email)
    }

    var eventParameters: [String: Any] {
        [
            "user_id": id,
            "user_email": email
        ]
    }

    static var mock: UserDataModel { mocks[0] }

    static var mocks: [UserDataModel] {
        [
            UserDataModel(id: "1", email: "example@gmail.com"),
            UserDataModel(id: "user_1", email: "user1@example.com"),
            UserDataModel(id: "user_2", email: "user2@example.com"),
            UserDataModel(id: "user_3", email: "user3@example.com")
        ]
    }
}
