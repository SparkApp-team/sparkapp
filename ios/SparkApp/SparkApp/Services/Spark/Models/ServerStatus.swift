//
//  ServerStatus.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 02.12.2025.
//


import SwiftUI

enum ServerStatus: Codable {
    case ok, bad, unknown

    private struct Payload: Codable {
        let status: String
    }

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

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let payload = try container.decode(Payload.self)
        self.init(status: payload.status)
    }

    func encode(to encoder: Encoder) throws {
        let rawStatus: String
        switch self {
        case .ok: rawStatus = "ok"
        case .bad: rawStatus = "bad"
        case .unknown: rawStatus = "unknown"
        }
        var container = encoder.singleValueContainer()
        try container.encode(Payload(status: rawStatus))
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
