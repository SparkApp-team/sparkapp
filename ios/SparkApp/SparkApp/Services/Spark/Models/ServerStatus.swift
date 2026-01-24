//
//  ServerStatus.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//


import SwiftUI

enum ServerStatus: Codable {
    case ok, bad, unknown
    
    init(status: String) {
        switch status {
        case "ok":
            self = .ok
        case "bad":
            self = .bad
        default:
            self = .unknown
        }
    }
    
    var color: Color {
        switch self {
        case .ok:
            Color.green
        case .bad:
            AppColors.P2.primary
        case .unknown:
            AppColors.P2.textPrimary
        }
    }
    
    static var goodMock: Self {
        ServerStatus(status: "ok")
    }
    
    static var badMock: Self {
        ServerStatus(status: "bad")
    }
    
    static var unknownMock: Self {
        ServerStatus(status: "default")
    }
}
