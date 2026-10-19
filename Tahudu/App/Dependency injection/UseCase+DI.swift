//
//  UseCase+DI.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

extension DIContainer {
    func registerSearchUseCase() {
        register(SearchUseCaseProtocol.self) {
            SearchUseCase(repo: self.resolve(SearchRepositoryProtocol.self))
        }
    }

    func registerFavouritesUseCase() {
        register(FavouritesUseCaseProtocol.self) {
            FavouritesUseCase(repo: self.resolve(FavouritesRepositoryProtocol.self))
        }
    }
}
