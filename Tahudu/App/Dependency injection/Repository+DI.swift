//
//  Repository+DI.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

import Foundation

extension DIContainer {
    func registerSearchRepository() {
        register(SearchRepositoryProtocol.self) {
            SearchRepository(service: self.resolve(NetworkServiceProtocol.self))
        }
    }

    func registerFavouritesRepository() {
        register(FavouritesRepositoryProtocol.self) {
            FavouritesRepository()
        }
    }
}
