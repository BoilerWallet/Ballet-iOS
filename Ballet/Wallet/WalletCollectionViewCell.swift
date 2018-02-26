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
import BigInt

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

    var currentAccount: Account?

    var cellSelected: ((_ account: Account) -> Void)?

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

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellClicked)))

        // Card setup
        /*
        backgroundColor = .white
        setShadowElevation(.cardResting, for: .normal)
        setShadowColor(.black, for: .normal)
        setBorderWidth(0.5, for: .normal)
        setBorderColor(Colors.darkSecondaryTextColor, for: .normal)*/
    }

    // MARK: - Cell setup

    func setup(with account: Account, cellSelected: ((_ account: Account) -> Void)? = nil) {
        self.currentAccount = account
        self.cellSelected = cellSelected

        // Reset
        blockiesImage.image = nil
        nameLabel.text = ""
        balanceLabel.text = "0 ETH"
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

        RPC.activeWeb3?.eth.getBalance(address: address, block: .latest, response: { [weak self] response in
            guard let quantity = response.rpcResponse?.result, response.status == .ok else {
                return
            }

            let value = quantity.convertWeiToEthString()

            DispatchQueue.main.async {
                self?.balanceLabel.text = value + " ETH"
            }
        })
    }

    // MARK: - Actions

    @objc private func cellClicked() {
        if let account = currentAccount {
            cellSelected?(account)
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
        setShadowElevation(.cardResting, for: .highlighted)
    }
}
