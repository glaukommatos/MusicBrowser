//
//  SearchResultsViewController.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 25.07.21.
//

import UIKit
import Combine

class SearchResultsViewController: BaseViewController, UISearchResultsUpdating {
    private var subscriptions = Set<AnyCancellable>()
    private weak var searchIconView: UIView?

    lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: self)
        searchController.searchResultsUpdater = self
        return searchController
    }()

    private lazy var viewModel = SearchViewModel(
        sessionRepository: SessionRepository(
            dataProvider: DataProvider()
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeCollectionView()
        preserveSearchIconView()
        bindViewModel()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.searchTextField.text else { return }
        // This could well be worth debouncing, but it hasn't caused any noticable issue for me as of yet
        displaySearchResults(sessions: [])
        viewModel.search(for: searchTerm)
    }

    private func customizeCollectionView() {
        collectionView.accessibilityIdentifier = "SearchResults"
    }

    private func preserveSearchIconView() {
        self.searchIconView = searchController.searchBar.searchTextField.leftView
    }

    private func bindViewModel() {
        viewModel.searchResults
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { [weak self] sessions in
                self?.displaySearchResults(sessions: sessions)
            }.store(in: &subscriptions)

        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                self?.showLoadingIndicator(loading)
        }.store(in: &subscriptions)
    }

    private func displaySearchResults(sessions: [Session]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Session>()
        snapshot.appendSections([0])
        snapshot.appendItems(sessions)
        dataSource.apply(snapshot)
    }

    private func showLoadingIndicator(_ shouldShow: Bool) {
        if shouldShow {
            let indicator = UIActivityIndicatorView()
            indicator.startAnimating()
            searchController.searchBar.searchTextField.leftView = indicator
        } else {
            searchController.searchBar.searchTextField.leftView = searchIconView
        }
    }
}
