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

    private var loadingUID = ""

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

    func setup(with token: ERC20TrackedToken, for address: EthereumAddress) {
        let id = UUID().uuidString
        loadingUID = id

        let web3 = RPC.activeWeb3
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: try? EthereumAddress(hex: token.addressString, eip55: false))

        tokenNameLabel.text = token.name
        tokenAddressLabel.text = token.addressString

        blockiesImage.setBlockies(with: token.addressString.lowercased())

        tokenBalanceLabel.text = "Loading..."
        firstly {
            contract.balanceOf(address: address).call()
        }.then { balance in
            unwrap(balance["_balance"] as? BigUInt)
        }.done { [weak self] balance in
            guard let s = self else {
                return
            }
            if s.loadingUID == id {
                let balanceDecimal = BigUDecimal(balance) / BigUDecimal(BigUInt(10).power(token.decimals))
                s.tokenBalanceLabel.text = "\(balanceDecimal.description) \(token.symbol)"
            }
        }.catch { [weak self] error in
            guard let s = self else {
                return
            }
            if s.loadingUID == id {
                s.tokenBalanceLabel.text = "⚠️ Error ⚠️"
            }
        }
    }
}
