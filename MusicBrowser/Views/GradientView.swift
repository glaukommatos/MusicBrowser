//
//  GradientView.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 27.07.21.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        guard let gradientLayer = layer as? CAGradientLayer else { fatalError("GradientView layer is wrong.") }

        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 1]
    }
}
