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
import PromiseKit
import MaterialComponents.MaterialButtons
import Cartography

class TransactionConfirmationViewController: UIViewController {

    // MARK: - Properties

    var completion: (() -> Void)?

    var transaction: PreparedTransaction!
    private var nonceQuantity: EthereumQuantity!

    @IBOutlet weak var loadingView: LoadingView!

    @IBOutlet weak var sendButton: MDCRaisedButton!
    @IBOutlet weak var cancelButton: MDCRaisedButton!

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
        setupTransactionLabels()
        setupButtons()
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

    private func setupTransactionLabels() {
        let labels: [UILabel] = [
            toAddressInfo, toAddress,
            fromAddressInfo, fromAddress,
            amountInfo, amount,
            balanceInfo, balance,
            coinInfo, coin,
            networkInfo, network,
            gasLimitInfo, gasLimit,
            gasPriceInfo, gasPrice,
            txFeeInfo, txFee,
            nonceInfo, nonce
        ]

        for l in labels {
            l.setupSubTitleLabel()
        }
    }

    func setupButtons() {
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        sendButton.setBackgroundColor(Colors.accentColor)
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        cancelButton.setBackgroundColor(Colors.darkSecondaryTextColor)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }

    // MARK: - UI filling

    private func fillUI() {
        fillInfo()
        fillBlockies()
        fillTransactionLabels()
        fillAsyncInfo()
    }

    private func fillInfo() {
        infoLabel.text = "You are about to send..."
    }

    private func fillBlockies() {
        if let privateKey = try? transaction.from.ethereumPrivateKey() {
            fromBlockies.setBlockies(with: privateKey.address.hex(eip55: false))
            fromBlockiesAddress.text = privateKey.address.hex(eip55: true)
        }

        toBlockies.setBlockies(with: transaction.to.hex(eip55: false))
        toBlockiesAddress.text = transaction.to.hex(eip55: true)

        blockiesArrowDetail.text = "\(String(transaction.amount.quantity, radix: 10).weiToEthStr()) ETH"
    }

    private func fillTransactionLabels() {
        toAddressInfo.text = "To Address:"
        toAddress.text = transaction.to.hex(eip55: true)

        fromAddressInfo.text = "From Address:"
        fromAddress.text = try? transaction.from.ethereumPrivateKey().address.hex(eip55: true)

        amountInfo.text = "Amount to Send:"
        amount.text = "\(String(transaction.amount.quantity, radix: 10).weiToEthStr()) ETH"

        balanceInfo.text = "Account Balance:"
        balance.text = "??? ETH"

        coinInfo.text = "Coin:"
        coin.text = "ETH"

        networkInfo.text = "Network:"
        network.text = "ETH (chain \(transaction.rpcUrl.chainId)) via \(transaction.rpcUrl.url)"

        gasLimitInfo.text = "Gas Limit:"
        gasLimit.text = "21000"

        gasPriceInfo.text = "Gas Price:"
        gasPrice.text = "\(String(transaction.gasPrice.quantity, radix: 10).weiToGweiStr()) gwei"

        txFeeInfo.text = "Max TX Fee:"
        txFee.text = "\(String(transaction.gasPrice.quantity * 21000, radix: 10).weiToEthStr()) ETH"

        nonceInfo.text = "Nonce:"
        nonce.text = "???"
    }

    private func fillAsyncInfo() {
        loadingView.startLoading()

        guard let from = try? transaction.from.ethereumPrivateKey().address else {
            self.dismiss(animated: true, completion: nil)
            return
        }

        let web3 = Web3(rpcURL: transaction.rpcUrl.url)

        firstly {
            when(fulfilled: web3.eth.getBalance(address: from, block: .latest), web3.eth.getTransactionCount(address: from, block: .latest))
        }.done { balance, nonce in
            self.balance.text = "\(String(balance.quantity, radix: 10).weiToEthStr()) ETH"
            self.nonce.text = String(nonce.quantity, radix: 10)

            // Set nonce quantity for transaction
            self.nonceQuantity = nonce
        }.catch { error in
            self.dismiss(animated: true, completion: nil)
        }.finally {
            self.loadingView.stopLoading()
        }
    }

    // MARK: - Helpers

    private func showResult(for txHash: EthereumData, on vc: TransactionConfirmationResultViewController) {
        vc.txHashData = txHash
        vc.rpcUrl = transaction.rpcUrl

        // Embed controller
        addChildViewController(vc)
        view.addSubview(vc.view)
        constrain(view, vc.view) { container, embedded in
            embedded.top == container.top
            embedded.bottom == container.bottom
            embedded.left == container.left
            embedded.right == container.right
        }
        vc.didMove(toParentViewController: self)
    }

    // MARK: - Actions

    @objc private func sendButtonClicked() {
        loadingView.startLoading()

        let tx = EthereumTransaction(
            nonce: nonceQuantity,
            gasPrice: transaction.gasPrice,
            gasLimit: 21000,
            to: transaction.to,
            value: transaction.amount,
            chainId: EthereumQuantity(integerLiteral: UInt64(transaction.rpcUrl.chainId))
        )
        let web3 = Web3(rpcURL: transaction.rpcUrl.url)

        firstly {
            self.transaction.from.signTransaction(tx)
        }.then { tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { txHash in
            let c = UIStoryboard(name: "TransactionConfirmation", bundle: nil)
                .instantiateViewController(withIdentifier: "TransactionConfirmationResult")
                as? TransactionConfirmationResultViewController
            c.map({ self.showResult(for: txHash, on: $0) })
            self.completion?()
        }.catch { error in
            let text: String
            if let _ = error as? RPCResponse<EthereumData>.Error {
                text = "Your transaction was rejected. Please recheck your inputs and try again."
            } else {
                text = "Something unexpected went wrong. Please try again later."
            }
            Dialog().details(text).positive("OK", handler: nil).show(self)
        }.finally {
            self.loadingView.stopLoading()
        }
    }

    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
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
