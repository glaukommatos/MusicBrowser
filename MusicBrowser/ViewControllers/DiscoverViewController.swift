//
//  DiscoverViewController.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 24.07.21.
//

import UIKit
import Combine

class DiscoverViewController: BaseViewController {
    private var subscriptions = Set<AnyCancellable>()

    private let resultsCollectionController = SearchResultsViewController(
        collectionViewLayout: DualColumnFlowLayout()
    )

    private let viewModel = DiscoverViewModel(
        radioRepository: SessionRepository(
            dataProvider: DataProvider()
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeCollectionView()
        customizeNavigation()
        prepareSearchController()
        bindToViewModel()
        prepareDataSource()
        viewModel.fetchMore()
    }

    private func customizeCollectionView() {
        collectionView.accessibilityIdentifier = "DiscoverResults"
    }

    private func customizeNavigation() {
        title = "Discovery"
    }

    private func prepareSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = resultsCollectionController.searchController
    }

    private func bindToViewModel() {
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.showLoadingIndicator(isLoading)
            }.store(in: &subscriptions)

        viewModel
            .sessions
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { [weak self] sessions in
                self?.addSessions(sessions: sessions)
            }.store(in: &subscriptions)
    }

    private func prepareDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Session>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot)
    }

    private func addSessions(sessions: [Session]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(sessions)
        dataSource.apply(snapshot)
    }

    private func showLoadingIndicator(_ display: Bool) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.footerReferenceSize.height = display ? 50 : 0
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == dataSource.collectionView(collectionView, numberOfItemsInSection: 0) - 1 {
            viewModel.fetchMore()
        }
    }
}
