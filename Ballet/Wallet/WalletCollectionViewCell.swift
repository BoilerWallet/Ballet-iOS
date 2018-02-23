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

class WalletCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private let blockiesGenerationQueue = DispatchQueue(label: "BlockiesGeneration")

    @IBOutlet weak var content: WalletCollectionViewCellContent!

    var blockiesImage: UIImageView {
        return content.blockiesImage
    }

    var nameLabel: UILabel {
        return content.nameLabel
    }

    var balanceLabel: UILabel {
        return content.balanceLabel
    }

    var addressLabel: UILabel {
        return content.addressLabel
    }

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
        /*
        backgroundColor = .white
        setShadowElevation(.cardResting, for: .normal)
        setShadowColor(.black, for: .normal)
        setBorderWidth(0.5, for: .normal)
        setBorderColor(Colors.darkSecondaryTextColor, for: .normal)*/
    }

    // MARK: - Cell setup

    func setup(with account: Account) {
        // Reset
        blockiesImage.image = nil
        nameLabel.text = ""
        balanceLabel.text = "32.000 ETH"
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

class WalletCollectionViewCellContent: MDCCard {

    @IBOutlet weak var blockiesImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var balanceLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        blockiesImage.layer.cornerRadius = blockiesImage.bounds.width / 2
        blockiesImage.layer.masksToBounds = true
        nameLabel.setupTitleLabel()
        balanceLabel.setupSubTitleLabel()
        addressLabel.setupBodyLabel()

        // Setup Card
        backgroundColor = .white
        cornerRadius = 8
        setShadowElevation(.cardResting, for: .highlighted)
        // setBorderWidth(1, for: .normal)
        setBorderColor(UIColor.brown, for: .normal)
    }
}
