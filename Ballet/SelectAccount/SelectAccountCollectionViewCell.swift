//
//  SelectAccountCollectionViewCell.swift
//  Ballet
//
//  Created by Koray Koska on 01.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCards

class SelectAccountCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    @IBOutlet weak var contentCard: MDCCard!
    @IBOutlet weak var blockiesImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    private(set) var currentAccount: Account?

    var onClick: (() -> Void)?

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    // MARK: - UI setup

    private func setupUI() {
        blockiesImage.layer.cornerRadius = blockiesImage.bounds.width / 2
        blockiesImage.layer.masksToBounds = true

        nameLabel.setupTitleLabel()
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byTruncatingMiddle
        nameLabel.text = ""

        addressLabel.setupSubTitleLabel()
        addressLabel.textAlignment = .center
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressLabel.text = ""

        // Setup Card
        contentCard.backgroundColor = .white
        contentCard.setShadowElevation(.cardResting, for: .highlighted)

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardClicked)))
    }

    // MARK: - Cell setup

    func setup(with account: Account) {
        currentAccount = account

        // Reset
        nameLabel.text = ""
        addressLabel.text = ""
        blockiesImage.image = nil

        let address = try? account.ethereumPrivateKey().address

        nameLabel.text = account.name
        addressLabel.text = address?.hex(eip55: true)
        blockiesImage.setBlockies(with: address?.hex(eip55: false) ?? "")
    }

    // MARK: - Actions

    @objc private func cardClicked() {
        onClick?()
    }
}
