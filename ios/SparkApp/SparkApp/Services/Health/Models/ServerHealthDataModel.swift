//
//  ServerHealthDataModel.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//


import SwiftUI

enum ServerHealth: String, Codable {
    case good = "ok"
    case bad
    case unknown

    init(from decoder: any Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = ServerHealth(rawValue: raw) ?? .unknown
    }

    var color: Color {
        switch self {
        case .good:
            Color.green
        case .bad:
            AppColors.P2.primary
        case .unknown:
            AppColors.P2.textPrimary
        }
    }
}

struct ServerHealthDataModel: Codable {
    let status: ServerHealth

    var eventParameters: [String: Any] {
        [
            "server_status": status.rawValue
        ]
    }

    static var goodMock: Self {
        ServerHealthDataModel(status: .good)
    }
    
    static var badMock: Self {
        ServerHealthDataModel(status: .bad)
    }
    
    static var unknownMock: Self {
        ServerHealthDataModel(status: .unknown)
    }
}
