//
//  UserDataModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

struct UserDataModel: Hashable, Codable {
    let id: String
    let email: String

    init(id: String, email: String) {
        self.id = id
        self.email = email
    }

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case email
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
            UserDataModel(id: "1", email: "user1@example.com"),
            UserDataModel(id: "2", email: "user2@example.com"),
            UserDataModel(id: "3", email: "user3@example.com"),
            UserDataModel(id: "0", email: "example@gmail.com"),
        ]
    }
}
