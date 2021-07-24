//
//  DualColumnFlowLayout.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 27.07.21.
//

import UIKit

/**

 This is used to layout the UICollectionViews and respond to changes in layout.

 */

class DualColumnFlowLayout: UICollectionViewFlowLayout {
    let spacing: CGFloat = 16

    func cellWidth(bounds: CGRect) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let insets = collectionView.safeAreaInsets
        let width = (bounds.width - insets.left - insets.right -
            sectionInset.left - sectionInset.right - minimumInteritemSpacing) / 2

        if width < 0 {
            return 0
        } else {
            return width
        }
    }

    func updateCellSize(bounds: CGRect) {
        let cellWidth = cellWidth(bounds: bounds)
        itemSize = CGSize(
            width: cellWidth,
            height: cellWidth
        )
    }

    override func prepare() {
        super.prepare()

        sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing

        let bounds = collectionView?.bounds ?? .zero
        updateCellSize(bounds: bounds)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }

        let oldSize = collectionView.bounds.size
        guard oldSize != newBounds.size else { return false }

        updateCellSize(bounds: newBounds)
        return true
    }
}
