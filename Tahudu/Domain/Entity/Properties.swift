//
//  Properties.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 17/10/2026.
//

import Foundation

struct Listing: Codable, Hashable {
    let id: String
    let type: String
    let deliveryYear: Int
    let price: Int
    let currency: String
    let priceInclusive: Bool
    let location: String
    let bedrooms: Int?
    let bathrooms: Int
    let areaSqft: Int
    let publishedAt: String
    let lastContactedAt: String?
    let tags: [PropertyTag]
    let images: [String]
    let contactOptions: [ContactOption]
}

enum PropertyTag: Hashable, Codable, RawRepresentable {
    case verified
    case newConstruction
    case liveViewing
    /// Tags the app has no dedicated styling for yet (e.g. "sea_view"); still shown as a badge.
    case other(String)

    init(rawValue: String) {
        switch rawValue {
        case "verified": self = .verified
        case "new_construction": self = .newConstruction
        case "live_viewing": self = .liveViewing
        default: self = .other(rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .verified: return "verified"
        case .newConstruction: return "new_construction"
        case .liveViewing: return "live_viewing"
        case .other(let value): return value
        }
    }
}

extension Listing {
    init(from model: ListingResponse) {
        self.init(
            id: model.id,
            type: model.type,
            deliveryYear: model.deliveryYear,
            price: model.price,
            currency: model.currency,
            priceInclusive: model.priceInclusive,
            location: model.location,
            bedrooms: model.bedrooms,
            bathrooms: model.bathrooms,
            areaSqft: model.areaSqft,
            publishedAt: model.publishedAt,
            lastContactedAt: model.lastContactedAt,
            tags: model.tags?.filter { !$0.isEmpty }.map(PropertyTag.init(rawValue:)) ?? [],
            images: model.images ?? [],
            contactOptions: model.contactOptions?.compactMap(ContactOption.init(rawValue:)) ?? []
        )
    }

    static let empty = Listing(
        id: "",
        type: "",
        deliveryYear: 0,
        price: 0,
        currency: "",
        priceInclusive: false,
        location: "",
        bedrooms: nil,
        bathrooms: 0,
        areaSqft: 0,
        publishedAt: "",
        lastContactedAt: nil,
        tags: [],
        images: [],
        contactOptions: []
    )
    
    static let sample = Listing(
        id: "listing-001",
        type: "Apartment",
        deliveryYear: 2027,
        price: 4_500_000,
        currency: "EGP",
        priceInclusive: true,
        location: "New Cairo, Fifth Settlement",
        bedrooms: 3,
        bathrooms: 2,
        areaSqft: 1_650,
        publishedAt: "2026-10-01T09:30:00Z",
        lastContactedAt: "2026-10-12T14:15:00Z",
        tags: [PropertyTag.verified, PropertyTag.newConstruction, PropertyTag.liveViewing],
        images: ["first_image", "second_image"],
        contactOptions: [ContactOption.phone, ContactOption.whatsApp, ContactOption.email]
    )
}
