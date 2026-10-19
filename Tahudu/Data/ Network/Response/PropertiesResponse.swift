//
//  PropertiesResponse.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 17/10/2026.
//Data)

import Foundation

// MARK: - PropertiesResponse
struct PropertiesResponse: Codable {
    let listings: [ListingResponse]

    enum CodingKeys: String, CodingKey {
        case listings = "listings"
    }
}

// MARK: - Listing
struct ListingResponse: Codable {
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
    let tags: [String]?
    let images: [String]?
    let contactOptions: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case deliveryYear = "deliveryYear"
        case price = "price"
        case currency = "currency"
        case priceInclusive = "priceInclusive"
        case location = "location"
        case bedrooms = "bedrooms"
        case bathrooms = "bathrooms"
        case areaSqft = "areaSqft"
        case publishedAt = "publishedAt"
        case lastContactedAt = "lastContactedAt"
        case tags = "tags"
        case images = "images"
        case contactOptions = "contactOptions"
    }
}
