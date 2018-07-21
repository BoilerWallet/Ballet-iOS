//
//  ReceiveViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MaterialButtons
import Runes

class ReceiveViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var accountSelectionTitle: UILabel!
    @IBOutlet weak var accountSelectionView: DashedBorderView!
    @IBOutlet weak var selectedAccountImage: UIImageView!
    @IBOutlet weak var selectedAccountName: UILabel!
    @IBOutlet weak var selectedAccountAddress: UILabel!
    @IBOutlet weak var selectAccountButton: MDCFlatButton!
    
    @IBOutlet weak var qrCodeView: DashedBorderView!
    @IBOutlet weak var qrPlaceholderImage: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    private var selectedAccount: EncryptedAccount?
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = Colors.background

        setupToolbar()
        setupAccountSelection()
        setupQRCode()
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Receive"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
    }

    private func setupAccountSelection() {
        accountSelectionTitle.setupTitleLabel()
        accountSelectionTitle.text = "ACCOUNT"

        accountSelectionView.borderColor = Colors.darkSecondaryTextColor
        accountSelectionView.applyDashBorder()
        accountSelectionView.layer.cornerRadius = 5
        accountSelectionView.layer.masksToBounds = true

        selectedAccountImage.layer.cornerRadius = selectedAccountImage.bounds.width / 2
        selectedAccountImage.layer.masksToBounds = true

        selectedAccountName.setupTitleLabel()
        selectedAccountName.text = ""
        selectedAccountAddress.setupSubTitleLabel()
        selectedAccountAddress.text = ""

        // Select from button
        selectAccountButton.setTitleColor(Colors.accentColor, for: .normal)
        selectAccountButton.setTitle("Select Account", for: .normal)
        selectAccountButton.addTarget(self, action: #selector(selectAccountButtonClicked), for: .touchUpInside)
    }

    private func setupQRCode() {
        qrCodeView.borderColor = Colors.darkSecondaryTextColor
        qrCodeView.applyDashBorder()
        qrCodeView.layer.cornerRadius = 5
        qrCodeView.layer.masksToBounds = true

        qrPlaceholderImage.image = UIImage(named: "ic_qrcode")
    }

    // MARK: - Helper functions

    private func selectAccount(account: EncryptedAccount) {
        self.selectedAccount = account

        selectedAccountImage.setBlockies(with: account.address.hex(eip55: false))
        selectedAccountName.text = account.account.name
        selectedAccountAddress.text = account.address.hex(eip55: true)

        // Generate QR Code
        let rpc = RPC.activeUrl
        guard let url = "ethereum:\(account.address.hex(eip55: false))@\(rpc.chainId)".data(using: .utf8) else {
            return
        }

        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(url, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")

        var image = filter?.outputImage

        let scaleX = max(Screen.width, Screen.height) / (image?.extent.size.width ?? 1)
        let scaleY = max(Screen.width, Screen.height) / (image?.extent.size.height ?? 1)

        // Scale image
        image = image?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        qrCodeImage.image = UIImage.init <^> image
    }

    // MARK: - Actions

    @objc private func selectAccountButtonClicked() {
        guard let controller = UIStoryboard(name: "SelectAccount", bundle: nil).instantiateInitialViewController() as? SelectAccountCollectionViewController else {
            return
        }

        controller.completion = { [weak self] account in
            self?.selectAccount(account: account)
        }

        PopUpController.instantiate(from: self, with: controller)
    }
}
