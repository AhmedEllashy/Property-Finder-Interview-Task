//
//  NetworkError.swift
//  paratice-live-coding
//
//  Created by Ahmad Ellashy on 15/10/2026.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case auth
    case notExist
    case decode
    case invalidURL
    case invalidResponse
    case badStatusCode
    case forbidden(message: String)
    case other(message: String)
    
    var errorDescription: String? {
        switch self {
        case .auth:
            "Sign in Required"
        case .notExist:
            "No Data Found"
        case .decode:
            "Unexpected response from the server"
        case .invalidURL:
            "Invalid URL"
        case .invalidResponse:
            "Invalid Response"
        case .badStatusCode:
            "The server returned an error"
        case .forbidden(let message), .other(let message):
            message
        }
    }
}
