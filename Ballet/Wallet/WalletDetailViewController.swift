//
//  WalletDetailViewController.swift
//  Ballet
//
//  Created by Koray Koska on 26.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialSnackbar
import Web3
import BlockiesSwift
import Material
import MarqueeLabel

class WalletDetailViewController: UIViewController {

    struct WalletDetailMotionIdentifiers {

        let container: String
        let blockies: String
        let name: String
        let balance: String
        let address: String
    }

    // MARK: - Properties

    var account: Account!
    var motionIdentifiers: WalletDetailMotionIdentifiers?

    @IBOutlet weak var walletInfoView: UIView!
    @IBOutlet weak var blockiesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var addressLabel: MarqueeLabel!
    @IBOutlet weak var copyAddressButton: IconButton!
    @IBOutlet weak var erc20Button: MDCRaisedButton!

    @IBOutlet weak var historyInfoLabel: UILabel!

    private var key: EthereumPrivateKey?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        guard account != nil else {
            dismiss(animated: true, completion: nil)
            return
        }

        setupUI()
        fillUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = Colors.background
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor

        blockiesImageView.layer.cornerRadius = blockiesImageView.bounds.width / 2
        blockiesImageView.layer.masksToBounds = true

        nameLabel.setupTitleLabelWithSize(size: 20)
        nameLabel.textAlignment = .center

        balanceLabel.setupBodyLabel()

        addressLabel.setupSubTitleLabel()
        addressLabel.textAlignment = .center

        let copyImage = UIImage(named: "ic_content_copy")?.withRenderingMode(.alwaysTemplate)
        copyAddressButton.setImage(copyImage, for: .normal)
        copyAddressButton.tintColor = Colors.darkSecondaryTextColor
        copyAddressButton.addTarget(self, action: #selector(copyAddressButtonClicked), for: .touchUpInside)

        erc20Button.setTitle("ERC20 Tokens", for: .normal)
        erc20Button.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        erc20Button.setBackgroundColor(Colors.accentColor)

        blockiesImageView.image = nil
        balanceLabel.text = "0.000000000000000000 ETH"
        addressLabel.text = ""

        historyInfoLabel.setupSubTitleLabel()
        historyInfoLabel.text = "History (Transactions)"

        // Motion
        walletInfoView.motionIdentifier = motionIdentifiers?.container
        blockiesImageView.motionIdentifier = motionIdentifiers?.blockies
        nameLabel.motionIdentifier = motionIdentifiers?.name
        balanceLabel.motionIdentifier = motionIdentifiers?.balance
        addressLabel.motionIdentifier = motionIdentifiers?.address
    }

    private func fillUI() {
        navigationItem.titleLabel.text = "Details"

        nameLabel.text = account.name

        guard let key = try? account.ethereumPrivateKey() else {
            return
        }
        self.key = key

        blockiesImageView.setBlockies(with: key.address.hex(eip55: false))

        RPC.activeWeb3?.eth.getBalance(address: key.address, block: .latest, response: { response in
            guard let quantity = response.rpcResponse?.result, response.status == .ok else {
                return
            }

            DispatchQueue.main.sync { [weak self] in
                self?.balanceLabel.text = quantity.convertWeiToEthString() + " ETH"
            }
        })

        addressLabel.text = key.address.hex(eip55: true)
        let second = DispatchTime.now().uptimeNanoseconds + 1000000000
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: second)) { [weak self] in
            self?.addressLabel.triggerScrollStart()
        }
    }

    // MARK: - Actions

    @objc private func copyAddressButtonClicked() {
        UIPasteboard.general.string = key?.address.hex(eip55: true)

        let success = MDCSnackbarMessage()
        success.text = "Successfully copied your address to the clipboard."

        MDCSnackbarManager.show(success)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
