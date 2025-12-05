//
//  Status.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//


import SwiftUI

struct Status: Codable {
    let status: String
    
    var color: Color {
        switch status.lowercased() {
        case "ok":
            return Color.green
        case "bad":
            return AppColors.P2.primary
        default:
            return AppColors.P2.textPrimary
        }
    }
}
