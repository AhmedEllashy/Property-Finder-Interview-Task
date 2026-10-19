//
//  SearchViewModel.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 17/10/2026.
//

import Foundation

@MainActor
@Observable
final class SearchViewModel {
    private let searchUseCase: SearchUseCaseProtocol
    private let favouritesUseCase: FavouritesUseCaseProtocol
    enum State { case idle, loading, success([Listing]), error(String) }

    private(set) var state: State = .idle

    var showFavoritesOnly = false
    var searchText: String = ""
    private(set) var favouriteIDs: Set<String>

    var visibleListings: [Listing] {
        guard case .success(let listings) = state else {
            return []
        }

        return showFavoritesOnly
        ? listings.filter { favouriteIDs.contains($0.id) }
            : listings
    }

    init(useCase: SearchUseCaseProtocol, favouritesUseCase: FavouritesUseCaseProtocol) {
        self.searchUseCase = useCase
        self.favouritesUseCase = favouritesUseCase
        self.favouriteIDs = favouritesUseCase.favouriteIDs()
    }

    func isFavourite(_ listing: Listing) -> Bool {
        favouriteIDs.contains(listing.id)
    }

    func toggleFavourite(_ listing: Listing) {
        favouriteIDs = favouritesUseCase.toggleFavourite(id: listing.id)
    }
    
    func loadIfNeeded() async {
        if case .success = state { return }
        await fetchListings()
    }

    func fetchListings() async {
        state = .loading
        await loadListings()
    }

    func refresh() async {
        await loadListings()
    }

    private func loadListings() async {
        do {
            let listings = try await searchUseCase.fetchPropertiesList()
            state = .success(listings)
        } catch {
            // The view went away mid-request (e.g. tab switch); loadIfNeeded retries on next appearance.
            guard !Task.isCancelled else { return }
            state = .error(error.localizedDescription)
        }
    }
}
