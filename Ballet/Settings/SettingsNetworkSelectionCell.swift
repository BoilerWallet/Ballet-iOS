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

class SettingsNetworkSelectionCell: TableViewCell {

    // MARK: - Properties

    @IBOutlet weak var networkColor: UIView!

    @IBOutlet weak var networkNameLabel: UILabel!

    @IBOutlet weak var networkUrlLabel: UILabel!

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
    }

    // MARK: - Cell setup

    func setup(for url: RPCUrl) {
    }
}
