//
//  FavouritesRepository.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 19/10/2026.
//

import Foundation

protocol FavouritesRepositoryProtocol {
    func favouriteIDs() -> Set<String>
    func save(_ ids: Set<String>)
}

final class FavouritesRepository: FavouritesRepositoryProtocol {
    private let defaults: UserDefaults
    private let key = "favourite_listing_ids"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func favouriteIDs() -> Set<String> {
        Set(defaults.stringArray(forKey: key) ?? [])
    }

    func save(_ ids: Set<String>) {
        defaults.set(Array(ids), forKey: key)
    }
}
