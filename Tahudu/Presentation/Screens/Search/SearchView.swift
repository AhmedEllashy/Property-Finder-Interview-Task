//
//  SearchView.swift
//  Tahudu
//

import SwiftUI

struct SearchView: View {
    @Bindable var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .task {
                await viewModel.loadIfNeeded()
            }
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            topBar
            
            searchBar

            favouritesFilter

            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                VStack {
                    ProgressView()
                    Spacer()
                }
            case .success(_):
                listingsContent(viewModel.visibleListings)
            case .error(let error):
                ErrorView(message: error) {
                    Task {
                        await viewModel.fetchListings()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var topBar: some View {
        HStack(spacing: 16) {
            Button {
                print("Filters tapped")
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            .accessibilityLabel("Filters")

            Button {
                print("Sort tapped")
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
            .accessibilityLabel("Sort")

            Spacer()

            Button {
                print("Save search tapped")
            } label: {
                Image(systemName: "star")
            }
            .accessibilityLabel("Save search")
        }
        .foregroundStyle(Color.accentColor)
    }
    
    private var searchBar: some View {
        ClearableTextField(
            label: "City, area or building",
            text: $viewModel.searchText
        )
    }

    private var favouritesFilter: some View {
        let isActive = viewModel.showFavoritesOnly

        return Button {
            withAnimation {
                viewModel.showFavoritesOnly.toggle()
            }
        } label: {
            Label(
                isActive ? "Favourites only" : "Favourites",
                systemImage: isActive ? "heart.fill" : "heart"
            )
            .font(.caption)
            .foregroundStyle(isActive ? Color.white : Color.accentColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(isActive ? Color.accentColor : Color.clear)
            }
            .overlay {
                Capsule()
                    .stroke(Color.accentColor, lineWidth: 1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
    
    @ViewBuilder
    private func listingsContent(_ listings: [Listing]) -> some View {
        if listings.isEmpty {
            emptyState
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            propertiesList(listings)
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if viewModel.showFavoritesOnly {
            ContentUnavailableView {
                Label("No favourites yet", systemImage: "heart")
            } description: {
                Text("Tap the heart on a listing to save it here.")
            } actions: {
                Button("Show all listings") {
                    withAnimation {
                        viewModel.showFavoritesOnly = false
                    }
                }
            }
        } else {
            ContentUnavailableView(
                "No listings",
                systemImage: "house",
                description: Text("Check back later for new properties.")
            )
        }
    }

    private func propertiesList(_ listings: [Listing]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(listings, id: \.self) { listing in
                    PropertyCardView(
                        listing: listing,
                        isFavourite: viewModel.isFavourite(listing),
                        onFavouriteTapped: {
                            withAnimation {
                                viewModel.toggleFavourite(listing)
                            }
                        }
                    )
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
//        SearchView()
    }
}
