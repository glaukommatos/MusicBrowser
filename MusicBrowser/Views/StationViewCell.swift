//
//  StationViewCell.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 25.07.21.
//

import UIKit

class StationViewCell: UICollectionViewCell {
    static let nibName = "StationViewCell"
    static let reuseIdentifier = "StationViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var currentListenersLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentListenersContainerView: UIVisualEffectView!

    var session: Session? {
        didSet {
            if let session = session {
                currentListenersLabel.text = "🎧 \(session.listenerCount)"
                titleLabel.text = session.name
                genresLabel.text = session.genres.joined(separator: ", ")
                if let imageData = session.imageData {
                    backgroundImage.image = UIImage(data: imageData)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 10
        currentListenersContainerView.layer.cornerRadius = 10
    }
}
