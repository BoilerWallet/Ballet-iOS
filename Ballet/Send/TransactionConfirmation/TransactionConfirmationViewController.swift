//
//  TransactionConfirmationViewController.swift
//  Ballet
//
//  Created by Koray Koska on 02.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3
import BigInt

class TransactionConfirmationViewController: UIViewController {

    // MARK: - Properties

    var transaction: PreparedTransaction!

    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var fromBlockies: UIImageView!
    @IBOutlet weak var fromBlockiesAddress: UILabel!

    @IBOutlet weak var blockiesArrow: UIImageView!
    @IBOutlet weak var blockiesArrowDetail: UILabel!

    @IBOutlet weak var toBlockies: UIImageView!
    @IBOutlet weak var toBlockiesAddress: UILabel!

    @IBOutlet weak var toAddressInfo: UILabel!
    @IBOutlet weak var toAddress: UILabel!

    @IBOutlet weak var fromAddressInfo: UILabel!
    @IBOutlet weak var fromAddress: UILabel!

    @IBOutlet weak var amountInfo: UILabel!
    @IBOutlet weak var amount: UILabel!

    @IBOutlet weak var balanceInfo: UILabel!
    @IBOutlet weak var balance: UILabel!

    @IBOutlet weak var coinInfo: UILabel!
    @IBOutlet weak var coin: UILabel!

    @IBOutlet weak var networkInfo: UILabel!
    @IBOutlet weak var network: UILabel!

    @IBOutlet weak var gasLimitInfo: UILabel!
    @IBOutlet weak var gasLimit: UILabel!

    @IBOutlet weak var gasPriceInfo: UILabel!
    @IBOutlet weak var gasPrice: UILabel!

    @IBOutlet weak var txFeeInfo: UILabel!
    @IBOutlet weak var txFee: UILabel!

    @IBOutlet weak var nonceInfo: UILabel!
    @IBOutlet weak var nonce: UILabel!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        guard transaction != nil else {
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

    // MARK: - UI setup

    private func setupUI() {
        setupInfo()
        setupBlockies()
    }

    private func setupInfo() {
        infoLabel.setupSubTitleLabelWithSize(size: 22)
        infoLabel.textAlignment = .center
    }

    private func setupBlockies() {
        fromBlockies.layer.cornerRadius = fromBlockies.bounds.width / 2
        fromBlockies.layer.masksToBounds = true

        fromBlockiesAddress.setupSubTitleLabel()
        fromBlockiesAddress.textAlignment = .center
        fromBlockiesAddress.lineBreakMode = .byTruncatingMiddle

        toBlockies.layer.cornerRadius = toBlockies.bounds.width / 2
        toBlockies.layer.masksToBounds = true

        toBlockiesAddress.setupSubTitleLabel()
        toBlockiesAddress.textAlignment = .center
        toBlockiesAddress.lineBreakMode = .byTruncatingMiddle

        let arrow = UIImage(named: "ic_arrow_forward_48pt")?.withRenderingMode(.alwaysTemplate)
        blockiesArrow.image = arrow
        blockiesArrow.tintColor = Colors.darkSecondaryTextColor
        blockiesArrowDetail.setupTitleLabelWithSize(size: 18)
        blockiesArrowDetail.textAlignment = .center
        blockiesArrowDetail.textColor = Colors.accentColor
    }

    // MARK: - UI filling

    private func fillUI() {
        fillInfo()
        fillBlockies()
    }

    private func fillInfo() {
        infoLabel.text = "You are about to send..."
    }

    private func fillBlockies() {
        if let from = try? transaction.from.ethereumPrivateKey().address.hex(eip55: true) {
            fromBlockies.setBlockies(with: from)
            fromBlockiesAddress.text = from
        }

        let to = transaction.to.hex(eip55: true)
        toBlockies.setBlockies(with: to)
        toBlockiesAddress.text = to

        blockiesArrowDetail.text = "\(String(transaction.amount.quantity, radix: 10).weiToEthStr()) ETH"
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

struct PreparedTransaction {

    let from: Account
    let to: EthereumAddress
    let amount: EthereumQuantity
    let gasPrice: EthereumQuantity

    let rpcUrl: RPCUrl
}
