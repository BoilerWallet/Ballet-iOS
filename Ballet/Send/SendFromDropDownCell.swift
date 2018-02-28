//
//  SendFromDropDownCell.swift
//  Ballet
//
//  Created by Koray Koska on 27.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import DropDown
import Cartography
import Web3
import BlockiesSwift

class SendFromDropDownCell: DropDownCell {

    private var currentAccount: Account?

    private var blockiesImage: UIImageView!
    private var nameLabel: UILabel!
    private var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        blockiesImage = UIImageView()
        nameLabel = UILabel()
        addressLabel = UILabel()

        addSubview(blockiesImage)
        addSubview(nameLabel)
        addSubview(addressLabel)

        constrain(self, blockiesImage, nameLabel, addressLabel) { container, blockies, name, address in
            blockies.width == container.height - 16
            blockies.height == container.height - 16
            blockies.left == container.left + 8
            blockies.centerY == container.centerY

            name.height == (container.height - 16) / 2
            name.left == blockies.right + 8
            name.right == container.right - 8
            name.top == container.top + 8

            address.height == (container.height - 16) / 2
            address.left == blockies.right + 8
            address.right == container.right - 8
            address.top == name.bottom
        }

        blockiesImage.layer.cornerRadius = blockiesImage.bounds.width / 2
        blockiesImage.layer.masksToBounds = true

        nameLabel.setupTitleLabel()

        addressLabel.setupSubTitleLabel()

        optionLabel.isHidden = true
    }

    func setAccount(account: Account) {
        currentAccount = account

        nameLabel.text = account.name

        let address = try? EthereumPrivateKey(hexPrivateKey: account.privateKey).address.hex(eip55: true)
        addressLabel.text = address ?? ""

        let scale = Int(ceil((blockiesImage.bounds.width * blockiesImage.bounds.height) / 24))
        DispatchQueue.global().async { [weak self] in
            let blockie = Blockies(seed: address ?? "", size: 8, scale: 3).createImageCached()

            DispatchQueue.main.sync {
                self?.blockiesImage.image = scale > 1 ? scale > 2 ? blockie?.high : blockie?.medium : blockie?.low
            }
        }
    }
}
