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
import Lottie

class BlockiesSelectionView: UIView {

    // MARK: - Properties

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var loadingView: LoadingView!

    @IBOutlet weak var first: BlockiesSelectionElement!
    @IBOutlet weak var second: BlockiesSelectionElement!
    @IBOutlet weak var third: BlockiesSelectionElement!
    @IBOutlet weak var fourth: BlockiesSelectionElement!
    @IBOutlet weak var fifth: BlockiesSelectionElement!
    @IBOutlet weak var sixth: BlockiesSelectionElement!

    private var accountViews: [BlockiesSelectionElement] = []
    private var accounts: [EthereumAddress] = []

    var completion: ((_ selectedAddress: EthereumAddress) -> Void)?

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
        accountViews = [first, second, third, fourth, fifth, sixth]
        setAccounts(accounts: accounts)

        for a in accountViews {
            a.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blockieClicked(_:))))
        }
    }

    // MARK: Setup

    func setAccounts(accounts: [EthereumAddress], completion: (() -> Void)? = nil) {
        var blockiesViews: [BlockiesSelectionElement] = accountViews
        self.accounts = accounts

        for a in accountViews {
            a.setSelected(false)
        }

        for i in 0..<accounts.count {
            if i > 5 {
                break
            }

            let seed = accounts[i].hex(eip55: false)
            let address = accounts[i].hex(eip55: true)
            blockiesViews[i].setBlockie(seed: seed, address: address)
        }

        completion?()
    }

    // MARK: - Actions

    @objc private func blockieClicked(_ gesture: UITapGestureRecognizer) {
        for i in 0..<accountViews.count {
            if gesture.view === accountViews[i] {
                accountViews[i].setSelected(true)
                if accounts.count > i {
                    completion?(accounts[i])
                }
            } else {
                accountViews[i].setSelected(false)
            }
        }
        for a in accountViews {
            a.setSelected(false)
        }
        (gesture.view as? BlockiesSelectionElement)?.setSelected(true)
    }
}

class BlockiesSelectionElement: UIView {

    private var imageView: UIImageView!
    private var addressLabel: UILabel!
    private var selectionView: UIView!
    private var selectionCheckView: LOTAnimationView!
    private var clickView: UIView!

    private(set) var isSelected = false

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        imageView = UIImageView()
        addressLabel = UILabel()

        selectionView = UIView()
        selectionView.backgroundColor = Colors.primaryColor.withAlphaComponent(0.56)

        selectionCheckView = LOTAnimationView(name: "material_check_pink")
        selectionView.addSubview(selectionCheckView)

        setSelected(false)

        clickView = UIView()
        clickView.backgroundColor = UIColor.clear

        addressLabel.setupSubTitleLabel()
        addressLabel.textAlignment = .center
        addressLabel.lineBreakMode = .byTruncatingMiddle

        addSubview(imageView)
        addSubview(addressLabel)
        addSubview(selectionView)
        addSubview(clickView)

        constrain(self, imageView, addressLabel, selectionView, selectionCheckView, clickView) { container, image, label, selection, check, click in
            label.left == container.left
            label.right == container.right
            label.bottom == container.bottom
            label.height == 24

            image.bottom == label.top - 8
            image.top == container.top + 8
            image.width == image.height
            image.centerX == container.centerX

            selection.left == container.left
            selection.right == container.right
            selection.top == container.top
            selection.bottom == container.bottom

            check.left == selection.left
            check.right == selection.right
            check.top == selection.top
            check.bottom == selection.bottom

            click.left == container.left
            click.right == container.right
            click.top == container.top
            click.bottom == container.bottom
        }
    }

    func setSelected(_ selected: Bool) {
        if selected {
            isSelected = true
            selectionView.isHidden = false
            selectionCheckView.play()
        } else {
            isSelected = false
            selectionView.isHidden = true
        }
    }

    func setBlockie(seed: String, address: String) {
        imageView.setBlockies(with: seed)
        addressLabel.text = address
    }

    func clearBlockie() {
        imageView.image = nil
        addressLabel.text = nil
    }
}
