//
//  HabitCreateRequestBody.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 08.07.2026.
//

struct HabitCreateRequestBody: Encodable {
    let name: String
    let frequency: String
}
