//
//  String.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 17/10/2026.
//
import Foundation

extension String {
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let isoFormatterNoFraction = ISO8601DateFormatter()

    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    var isoDate: Date? {
        Self.isoFormatter.date(from: self)
            ?? Self.isoFormatterNoFraction.date(from: self)
    }

    var timeAgo: String {
        guard let date = isoDate else { return self }
        return Self.relativeFormatter.localizedString(
            for: min(date, Date()),
            relativeTo: Date()
        )
    }

    var showDate: String {
        guard let date = isoDate else { return self }
        return date.formatted(
            .dateTime.day().month(.abbreviated).year()
                .locale(Locale(identifier: "en_US"))
        )
    }
}
