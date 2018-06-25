//
//  WalletERC20TokenListCollectionViewCell.swift
//  Ballet
//
//  Created by Koray Koska on 25.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3

class WalletERC20TokenListCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    @IBOutlet weak var blockiesImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var tokenBalanceLabel: UILabel!
    @IBOutlet weak var tokenAddressLabel: UILabel!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    // MARK: - UI setup

    private func setupUI() {
        blockiesImage.layer.cornerRadius = blockiesImage.bounds.width / 2
        blockiesImage.layer.masksToBounds = true

        tokenNameLabel.setupTitleLabel()
        tokenBalanceLabel.setupSubTitleLabel()
        tokenAddressLabel.setupBodyLabel()

        tokenNameLabel.text = "Loading..."
        tokenBalanceLabel.text = "Loading..."
        tokenAddressLabel.text = "Loading..."
    }

    // MARK: - Cell setup

    func setup(with token: ERC20TrackedToken, balance: String) {
        tokenNameLabel.text = token.name
        tokenBalanceLabel.text = "\(balance) \(token.symbol)"
        tokenAddressLabel.text = token.addressString

        blockiesImage.setBlockies(with: token.addressString.lowercased())
    }
}
