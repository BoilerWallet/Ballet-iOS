//
//  SettingsTokenTrackerTableViewCell.swift
//  Ballet
//
//  Created by Koray Koska on 24.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Web3

class SettingsTokenTrackerTableViewCell: TableViewCell {

    // MARK: - Properties

    @IBOutlet weak var blockiesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - UI setup

    private func setupUI() {
        blockiesImageView.layer.cornerRadius = blockiesImageView.bounds.width / 2
        blockiesImageView.layer.masksToBounds = true

        nameLabel.setupTitleLabel()
        addressLabel.setupSubTitleLabel()
    }

    // MARK: - Cell setup

    func setup(name: String, address: EthereumAddress) {
        blockiesImageView.setBlockies(with: address.hex(eip55: false))

        nameLabel.text = name
        addressLabel.text = address.hex(eip55: true)
    }
}
