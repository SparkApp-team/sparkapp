//
//  HabitModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

struct HabitDataModel: Hashable, Codable {
    let id: Int
    let userId: Int
    var name: String
    var frequency: String

    init(
        id: Int,
        userId: Int,
        name: String,
        frequency: String
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.frequency = frequency
    }

    var eventParameters: [String: Any] {
        [
            "habit_id": id,
            "habit_user_id": userId,
            "habit_name": name,
            "habit_frequency": frequency
        ]
    }

    static var mock: HabitDataModel { mocks[0] }
    
    static var mocks: [HabitDataModel] {
        [
            HabitDataModel(
                id: 1,
                userId: 1,
                name: "Drink Water",
                frequency: "daily"
            ),
            HabitDataModel(
                id: 2,
                userId: 1,
                name: "Push-ups",
                frequency: "daily"
            ),
            HabitDataModel(
                id: 3,
                userId: 2,
                name: "Read a Book",
                frequency: "weekly"
            )
        ]
    }
}
