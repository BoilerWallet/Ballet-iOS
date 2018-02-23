//
//  WalletCollectionViewCell.swift
//  Ballet
//
//  Created by Koray Koska on 23.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Web3
import BlockiesSwift
import Cartography
import MaterialComponents.MaterialCards

class WalletCollectionViewCell: MDCCardCollectionCell {

    // MARK: - Properties

    private let blockiesGenerationQueue = DispatchQueue(label: "BlockiesGeneration")

    @IBOutlet weak var blockiesImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var balanceLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    // MARK: - UI setup

    func setupUI() {
        // General
        blockiesImage.layer.cornerRadius = blockiesImage.bounds.width / 2
        blockiesImage.layer.masksToBounds = true
        nameLabel.setupTitleLabel()
        balanceLabel.setupSubTitleLabel()
        addressLabel.setupBodyLabel()
        // End General

        // Card setup
        isSelectable = true
        selectedImageTintColor = .blue
        cornerRadius = 8
        setShadowElevation(.init(6), for: .selected)
        setShadowColor(.black, for: .highlighted)
    }

    // MARK: - Cell setup

    func setup(with account: Account) {
        // Reset
        blockiesImage.image = nil
        nameLabel.text = ""
        balanceLabel.text = ""
        addressLabel.text = ""

        let address: EthereumAddress
        do {
            let privateKey = try EthereumPrivateKey(hexPrivateKey: account.privateKey)
            address = privateKey.address
        } catch {
            return
        }

        nameLabel.text = account.name

        addressLabel.text = address.hex(eip55: true)

        let scale = Int(ceil((blockiesImage.bounds.width * blockiesImage.bounds.height) / 24))
        blockiesGenerationQueue.async { [weak self] in
            let image = Blockies(seed: address.hex(eip55: false), size: 8, scale: 3).createImage(customScale: scale)

            DispatchQueue.main.sync { [weak self] in
                self?.blockiesImage.image = image
            }
        }
    }
}
