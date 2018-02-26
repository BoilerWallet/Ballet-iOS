//
//  WalletDetailViewController.swift
//  Ballet
//
//  Created by Koray Koska on 26.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import Web3
import BlockiesSwift

class WalletDetailViewController: UIViewController {

    struct WalletDetailMotionIdentifiers {

        let blockies: String
        let name: String
        let balance: String
        let address: String
    }

    // MARK: - Properties

    var account: Account!
    var motionIdentifiers: WalletDetailMotionIdentifiers?

    @IBOutlet weak var blockiesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var erc20Button: MDCRaisedButton!

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

        nameLabel.setupTitleLabelWithSize(size: 24)
        nameLabel.textAlignment = .center

        balanceLabel.setupBodyLabel()

        addressLabel.setupSubTitleLabel()
        addressLabel.textAlignment = .center

        erc20Button.setTitle("ERC20 Tokens", for: .normal)
        erc20Button.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        erc20Button.setBackgroundColor(Colors.accentColor)

        blockiesImageView.image = nil
        balanceLabel.text = "0.00000000000000000 ETH"
        addressLabel.text = ""

        // Motion
        blockiesImageView.motionIdentifier = motionIdentifiers?.blockies
        nameLabel.motionIdentifier = motionIdentifiers?.name
        balanceLabel.motionIdentifier = motionIdentifiers?.balance
        addressLabel.motionIdentifier = motionIdentifiers?.address
    }

    private func fillUI() {
        navigationItem.titleLabel.text = "Details"

        nameLabel.text = account.name

        guard let key = try? EthereumPrivateKey(hexPrivateKey: account.privateKey) else {
            return
        }

        let scale = Int(ceil((blockiesImageView.bounds.width * blockiesImageView.bounds.height) / 24))
        DispatchQueue.global().async { [weak self] in
            let blockie = Blockies(seed: key.address.hex(eip55: false), size: 8, scale: 3).createImage(customScale: scale)

            DispatchQueue.main.sync { [weak self] in
                self?.blockiesImageView.image = blockie
            }
        }

        RPC.activeWeb3?.eth.getBalance(address: key.address, block: .latest, response: { response in
            guard let quantity = response.rpcResponse?.result, response.status == .ok else {
                return
            }

            DispatchQueue.main.sync { [weak self] in
                self?.balanceLabel.text = quantity.convertWeiToEthString() + " ETH"
            }
        })

        addressLabel.text = key.address.hex(eip55: true)
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
