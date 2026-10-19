//
//  SearchUseCase.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

import Foundation

protocol SearchUseCaseProtocol {
    func fetchPropertiesList() async throws -> [Listing]
}

final class SearchUseCase: SearchUseCaseProtocol {
    private let repo: SearchRepositoryProtocol
    
    init(repo: SearchRepositoryProtocol) {
        self.repo = repo
    }
    
    func fetchPropertiesList() async throws -> [Listing] {
        let response = try await repo.fetchPropertiesList()
        return response.listings.compactMap { Listing(from: $0) }
    }
}
