//
//  BaseViewController.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 25.07.21.
//

// swiftlint:disable force_cast

import Foundation
import UIKit

/**

 Has some properties and does some initialization that are common
 to the discover and search collection views.

 */

class BaseViewController: UICollectionViewController {
    lazy var dataSource = UICollectionViewDiffableDataSource<Int, Session>(
        collectionView: collectionView
    ) { collectionView, indexPath, session in
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "StationViewCell", for: indexPath) as! StationViewCell
        cell.session = session
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeStatusBar()
        customizeCollectionView()
        registerCells()
        registerReusableViews()
        setupDataSource()
    }

    private func customizeStatusBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray5
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func customizeCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .always
    }

    private func registerCells() {
        let nib = UINib(nibName: StationViewCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: StationViewCell.reuseIdentifier)
    }

    private func registerReusableViews() {
        let nib = UINib(nibName: LoadingIndicatorFooterView.nibName, bundle: nil)
        collectionView.register(
            nib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingIndicatorFooterView.reuseIdentifier
        )
    }

    func setupDataSource() {
        collectionView.dataSource = dataSource
        dataSource.supplementaryViewProvider = supplementaryViewProvider(collectionView:kind:indexPath:)
    }

    private func supplementaryViewProvider(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingIndicatorFooterView.reuseIdentifier, for: indexPath
        ) as! LoadingIndicatorFooterView
    }
}
