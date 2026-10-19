//
//  FavouritesUseCase.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 19/10/2026.
//
import Foundation

protocol FavouritesUseCaseProtocol {
    func favouriteIDs() -> Set<String>
    /// Adds the listing if it isn't a favourite, removes it if it is, and returns the updated set.
    func toggleFavourite(id: String) -> Set<String>
}

final class FavouritesUseCase: FavouritesUseCaseProtocol {
    private let repo: FavouritesRepositoryProtocol

    init(repo: FavouritesRepositoryProtocol) {
        self.repo = repo
    }

    func favouriteIDs() -> Set<String> {
        repo.favouriteIDs()
    }

    func toggleFavourite(id: String) -> Set<String> {
        var ids = repo.favouriteIDs()
        if ids.remove(id) == nil {
            ids.insert(id)
        }
        repo.save(ids)
        return ids
    }
}
