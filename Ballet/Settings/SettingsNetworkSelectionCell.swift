//
//  SettingsNetworkSelectionCell.swift
//  Ballet
//
//  Created by Koray Koska on 19.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3
import Material
import BigInt
import MarqueeLabel
import Lottie
import Cartography

class SettingsNetworkSelectionCell: TableViewCell {

    // MARK: - Properties

    @IBOutlet weak var networkColor: UIView!

    @IBOutlet weak var networkNameLabel: UILabel!

    @IBOutlet weak var networkUrlLabel: UILabel!

    private var checkbox: LOTAnimationView!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - UI setup

    private func setupUI() {
        networkColor.layer.cornerRadius = networkColor.bounds.width / 2
        networkColor.layer.masksToBounds = true

        networkNameLabel.setupTitleLabel()
        networkUrlLabel.setupSubTitleLabel()

        checkbox = LOTAnimationView(name: "material_checkbox")
        checkbox.animationSpeed = 2.5
        addSubview(checkbox)

        constrain(self, checkbox) { container, checkbox in
            checkbox.width == 24
            checkbox.height == 24
            checkbox.right == container.right - 16
            checkbox.centerY == container.centerY
        }
    }

    // MARK: - Cell setup

    func setup(for url: RPCUrl) {
        networkNameLabel.text = url.name
        networkUrlLabel.text = url.url

        networkColor.backgroundColor = url.networkColor

        if url.isActive {
            checkbox.play()
        } else {
            checkbox.animationProgress = 0
        }
    }
}
