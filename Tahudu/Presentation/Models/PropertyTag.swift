//
//  PropertyTag.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

import SwiftUI

extension PropertyTag {
    var title: String {
        switch self {
        case .verified: return "VERIFIED"
        case .newConstruction: return "NEW CONSTRUCTION"
        case .liveViewing: return "LIVE VIEWING"
        case .other(let value): return value.replacingOccurrences(of: "_", with: " ").uppercased()
        }
    }

    var color: Color {
        switch self {
        case .verified: return .green
        case .newConstruction: return .blue
        case .liveViewing: return .red
        case .other: return .black.opacity(0.6)
        }
    }
}
