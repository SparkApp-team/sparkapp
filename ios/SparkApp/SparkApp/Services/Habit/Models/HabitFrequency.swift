//
//  HabitFrequency.swift
//  SparkApp
//
//  Created by Дмитро Крижановський on 12.07.2026.
//

import Foundation

enum HabitFrequency: String, CaseIterable, Identifiable {
    case daily, weekly, monthly
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}
