//
//  TahuduApp.swift
//  Tahudu
//

import SwiftUI

@main
struct TahuduApp: App {
    
    init() {
        DIContainer.shared.registerNetworkService()
        DIContainer.shared.registerSearchRepository()
        DIContainer.shared.registerFavouritesRepository()
        DIContainer.shared.registerSearchUseCase()
        DIContainer.shared.registerFavouritesUseCase()
    }
    
    var body: some Scene {
        WindowGroup {
            TahuduTabView()
        }
    }
}
