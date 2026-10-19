//
//  TahuduTabView.swift
//  Tahudu
//

import SwiftUI

struct TahuduTabView: View {
    @State private var selectedTab = Tabs.search.rawValue

    @State private var searchViewModel: SearchViewModel

    init() {
        let useCase = DIContainer.shared.resolve(SearchUseCaseProtocol.self)
        let favouritesUseCase = DIContainer.shared.resolve(FavouritesUseCaseProtocol.self)
        _searchViewModel = State(initialValue: SearchViewModel(useCase: useCase, favouritesUseCase: favouritesUseCase))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView(viewModel: searchViewModel)
                .tag(Tabs.search.rawValue)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView()
                .tag(Tabs.settings.rawValue)
                .tabItem {
                    Label("My Account", systemImage: selectedTab == Tabs.settings.rawValue ? "person.fill" : "person")
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
}

enum Tabs: Int, CaseIterable {
    case search = 0
    case settings

    var name: String {
        switch self {
        case .search:
            return "Search"
        case .settings:
            return "Settings"
        }
    }
}

struct TahuduTabView_Previews: PreviewProvider {
    static var previews: some View {
        TahuduTabView()
    }
}
