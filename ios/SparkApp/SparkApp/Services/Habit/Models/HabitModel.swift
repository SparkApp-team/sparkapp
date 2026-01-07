//
//  HabitModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

enum HabitType: String, CaseIterable, Hashable {
    case boolean
    case counter
}

struct HabitModel: Hashable {
    let id: String
    let userId: String?
    let name: String?
    let description: String?
    let type: HabitType?
    let createdAt: Date?
    let updatedAt: Date?
    
    init(
        id: String,
        userId: String? = nil,
        name: String? = nil,
        description: String? = nil,
        type: HabitType? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.description = description
        self.type = type
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static var mock: HabitModel { mocks[0] }
    
    static var mocks: [HabitModel] {
        [
            HabitModel(
                id: "habit_1",
                userId: "user_1",
                name: "Drink Water",
                description: "Drink 2 liters of water every day",
                type: .boolean,
                createdAt: Date().addingTimeInterval(-86400 * 3),
                updatedAt: Date().addingTimeInterval(-86400)
            ),
            
            HabitModel(
                id: "habit_2",
                userId: "user_1",
                name: "Push-ups",
                description: "Do 50 push-ups",
                type: .counter,
                createdAt: Date().addingTimeInterval(-86400 * 7),
                updatedAt: Date().addingTimeInterval(-86400 * 2)
            ),
            
            HabitModel(
                id: "habit_3",
                userId: "user_1",
                name: "Read a Book",
                description: "Read at least 20 pages",
                type: .boolean,
                createdAt: Date().addingTimeInterval(-86400 * 10),
                updatedAt: nil
            )
        ]
    }
}
