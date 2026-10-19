//
//  SearchRepository.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

import Foundation

protocol SearchRepositoryProtocol {
    func fetchPropertiesList() async throws -> PropertiesResponse
}

final class SearchRepository: SearchRepositoryProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func fetchPropertiesList() async throws -> PropertiesResponse {
        let request = SearchRequests.fetchPropertiesRequest()
        let response: PropertiesResponse = try await service.fetch(request: request)
        return response
    }
}
