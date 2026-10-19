//
//  FavouritesTests.swift
//  TahuduTests
//

import XCTest
@testable import Tahudu

final class FavouritesRepositoryTests: XCTestCase {
    private let suiteName = "FavouritesRepositoryTests"
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    func testStartsEmpty() {
        XCTAssertTrue(FavouritesRepository(defaults: defaults).favouriteIDs().isEmpty)
    }

    func testSavedIDsPersistAcrossInstances() {
        FavouritesRepository(defaults: defaults).save(["prop_001", "prop_002"])

        XCTAssertEqual(FavouritesRepository(defaults: defaults).favouriteIDs(), ["prop_001", "prop_002"])
    }
}

final class FavouritesUseCaseTests: XCTestCase {
    func testToggleAddsThenRemoves() {
        let repo = InMemoryFavouritesRepository()
        let useCase = FavouritesUseCase(repo: repo)

        XCTAssertEqual(useCase.toggleFavourite(id: "prop_001"), ["prop_001"])
        XCTAssertEqual(repo.ids, ["prop_001"])

        XCTAssertEqual(useCase.toggleFavourite(id: "prop_001"), [])
        XCTAssertEqual(repo.ids, [])
    }

    func testToggleKeepsOtherFavourites() {
        let repo = InMemoryFavouritesRepository(ids: ["prop_001"])
        let useCase = FavouritesUseCase(repo: repo)

        XCTAssertEqual(useCase.toggleFavourite(id: "prop_002"), ["prop_001", "prop_002"])
    }
}

final class SearchViewModelFavouritesTests: XCTestCase {
    @MainActor
    func testFavouritesAreLoadedOnInit() {
        let viewModel = makeViewModel(favourites: ["a"])

        XCTAssertTrue(viewModel.isFavourite(.stub(id: "a")))
        XCTAssertFalse(viewModel.isFavourite(.stub(id: "b")))
    }

    @MainActor
    func testToggleFavouriteUpdatesStateAndStorage() {
        let repo = InMemoryFavouritesRepository()
        let viewModel = makeViewModel(repo: repo)

        viewModel.toggleFavourite(.stub(id: "a"))

        XCTAssertTrue(viewModel.isFavourite(.stub(id: "a")))
        XCTAssertEqual(repo.ids, ["a"])
    }

    @MainActor
    func testFilterShowsOnlyFavourites() async {
        let viewModel = makeViewModel(favourites: ["b"])
        await viewModel.loadIfNeeded()

        viewModel.showFavoritesOnly = true

        XCTAssertEqual(viewModel.visibleListings.map(\.id), ["b"])
    }

    @MainActor
    func testUnfavouritingRemovesListingFromFilteredList() async {
        let viewModel = makeViewModel(favourites: ["a", "b"])
        await viewModel.loadIfNeeded()
        viewModel.showFavoritesOnly = true

        viewModel.toggleFavourite(.stub(id: "a"))

        XCTAssertEqual(viewModel.visibleListings.map(\.id), ["b"])
    }

    @MainActor
    func testFilterOffShowsAllListings() async {
        let viewModel = makeViewModel(favourites: ["b"])
        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.visibleListings.map(\.id), ["a", "b", "c"])
    }

    @MainActor
    private func makeViewModel(
        favourites: Set<String> = [],
        repo: InMemoryFavouritesRepository? = nil
    ) -> SearchViewModel {
        SearchViewModel(
            useCase: StubSearchUseCase(listings: [.stub(id: "a"), .stub(id: "b"), .stub(id: "c")]),
            favouritesUseCase: FavouritesUseCase(repo: repo ?? InMemoryFavouritesRepository(ids: favourites))
        )
    }
}

// MARK: - Test doubles

private final class InMemoryFavouritesRepository: FavouritesRepositoryProtocol {
    private(set) var ids: Set<String>

    init(ids: Set<String> = []) {
        self.ids = ids
    }

    func favouriteIDs() -> Set<String> { ids }
    func save(_ ids: Set<String>) { self.ids = ids }
}

private struct StubSearchUseCase: SearchUseCaseProtocol {
    let listings: [Listing]

    func fetchPropertiesList() async throws -> [Listing] { listings }
}

private extension Listing {
    static func stub(id: String) -> Listing {
        Listing(
            id: id,
            type: "Apartment",
            deliveryYear: 2024,
            price: 1_000_000,
            currency: "AED",
            priceInclusive: true,
            location: "Dubai Marina",
            bedrooms: 1,
            bathrooms: 1,
            areaSqft: 800,
            publishedAt: "2024-11-28T00:00:00Z",
            lastContactedAt: nil,
            tags: [],
            images: [],
            contactOptions: []
        )
    }
}
