//
//  BlockiesSelectionView.swift
//  Ballet
//
//  Created by Koray Koska on 19.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Cartography
import Web3
import BlockiesSwift

class BlockiesSelectionView: UIView {

    // MARK: - Properties

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var loadingView: LoadingView!

    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var second: UIImageView!
    @IBOutlet weak var third: UIImageView!
    @IBOutlet weak var fourth: UIImageView!
    @IBOutlet weak var fifth: UIImageView!
    @IBOutlet weak var sixth: UIImageView!

    private var accounts: [EthereumAddress] = []

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("BlockiesSelectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // setupUI()
    }

    // MARK: - UI setup

    private func setupUI() {
        setAccounts(accounts: accounts)
    }

    // MARK: Setup

    func setAccounts(accounts: [EthereumAddress], completion: (() -> Void)? = nil) {
        var imageViews: [UIImageView] = [first, second, third, fourth, fifth, sixth]
        self.accounts = accounts

        DispatchQueue(label: "BlockiesSelectionCreateBlockies").async {
            for i in 0..<accounts.count {
                if i > 5 {
                    break
                }
                var size: Int!
                DispatchQueue.main.sync {
                    size = Int(ceil((imageViews[i].bounds.width * imageViews[i].bounds.height) / 24))
                }

                let blockie = Blockies(seed: accounts[i].hex(eip55: false), size: 8, scale: 3).createImage(customScale: size)
                DispatchQueue.main.async {
                    imageViews[i].image = blockie
                }
            }
            DispatchQueue.main.sync {
                completion?()
            }
        }
    }
}
