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

class WalletCollectionViewCell: CollectionViewCell {

    // MARK: - Properties

    private let blockiesGenerationQueue = DispatchQueue(label: "BlockiesGeneration")

    @IBOutlet weak var content: WalletCollectionViewCellCard!

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

class WalletCollectionViewCellCard: UIView {

    private var card: PresenterCard!

    private var cardContent: UIView!

    private(set) var blockiesImage: UIImageView!

    private(set) var nameLabel: UILabel!

    private(set) var balanceLabel: UILabel!

    private(set) var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        blockiesImage = UIImageView()
        nameLabel = UILabel()
        balanceLabel = UILabel()
        addressLabel = UILabel()

        // General
        blockiesImage.layer.cornerRadius = blockiesImage.bounds.width / 2
        nameLabel.setupTitleLabel()
        balanceLabel.setupSubTitleLabel()
        addressLabel.setupBodyLabel()
        // End General

        let labelView = UIView()
        labelView.addSubview(nameLabel)
        labelView.addSubview(balanceLabel)
        labelView.addSubview(addressLabel)

        constrain(nameLabel, balanceLabel, addressLabel, labelView) { name, balance, address, container in
            name.height == 24
            name.left == container.left
            name.right == container.right
            name.top == container.top

            balance.height == 24
            balance.left == container.left
            balance.right == container.right
            balance.top == name.bottom + 8

            address.height == 24
            address.left == container.left
            address.right == container.right
            address.top == balance.bottom + 8
            address.bottom == container.bottom
        }

        cardContent = UIView()
        cardContent.addSubview(blockiesImage)
        cardContent.addSubview(labelView)

        constrain(blockiesImage, labelView, cardContent) { blockie, labelView, container in
            blockie.width == 56
            blockie.height == 56
            blockie.left == container.left + 16
            blockie.centerX == container.centerX

            labelView.left == blockie.right + 16
            labelView.right == container.right - 16
            labelView.centerY == container.centerY
        }

        card = PresenterCard()
        addSubview(card)
        constrain(self, card) { container, card in
            card.left == container.left
            card.right == container.right
            card.top == container.top
            card.bottom == container.bottom
        }

        card.contentView = cardContent
    }
}
