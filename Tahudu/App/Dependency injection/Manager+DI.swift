//
//  Manager+DI.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

extension DIContainer {
    func registerNetworkService() {
        register(NetworkServiceProtocol.self) {
            NetworkService()
        }
    }
}
