//
//  APIModels.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.07.2026.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct Endpoint {
    var path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: Data? = nil
}

enum APIError: Error {
    case invalidURL
    case badResponse(statusCode: Int, message: String?, data: Data)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request."
        case .badResponse(_, let message, _):
            return message ?? "Something went wrong. Please try again."
        }
    }
}

struct APIErrorResponse: Decodable {
    let status: Int
    let error: String
    let message: String
    let path: String
    // `timestamp` omitted — decoding ignores keys you don't declare
}
