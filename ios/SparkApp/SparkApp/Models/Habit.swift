//
//  Habit.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 26.11.2025.
//

import SwiftUI

struct Habit: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var userId: String = "user1"
    
    var name: String
    var description: String?
    
    var type: HabitType
    var targertValue: Int?
    
    //TODO: ...
    
    var createdAt: Date
    var updatedAt: Date
}

enum HabitType: String, Codable {
    case boolean
    case counter
}
