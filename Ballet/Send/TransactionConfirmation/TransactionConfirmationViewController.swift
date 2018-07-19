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
import Runes
import Curry

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
        let encryptedAccount = transaction.from
        fromBlockies.setBlockies(with: encryptedAccount.address.hex(eip55: false))
        fromBlockiesAddress.text = encryptedAccount.address.hex(eip55: true)

        toBlockies.setBlockies(with: transaction.to.hex(eip55: false))
        toBlockiesAddress.text = transaction.to.hex(eip55: true)

        blockiesArrowDetail.text = getBalanceText(balance: transaction.amount.quantity)
    }

    private func fillTransactionLabels() {
        let currencySymbol = transaction.currency?.symbol ?? "ETH"

        toAddressInfo.text = "To Address:"
        toAddress.text = transaction.to.hex(eip55: true)

        fromAddressInfo.text = "From Address:"
        fromAddress.text = transaction.from.address.hex(eip55: true)

        amountInfo.text = "Amount to Send:"
        amount.text = getBalanceText(balance: transaction.amount.quantity)

        balanceInfo.text = "Account Balance:"
        balance.text = "??? \(currencySymbol)"

        coinInfo.text = "Coin:"
        coin.text = "\(transaction.currency?.name ?? "ETH")"

        networkInfo.text = "Network:"
        network.text = "ETH (chain \(transaction.rpcUrl.chainId)) via \(transaction.rpcUrl.url)"

        gasLimitInfo.text = "Gas Limit:"
        gasLimit.text = "\(String(transaction.gas.quantity, radix: 10))"

        gasPriceInfo.text = "Gas Price:"
        gasPrice.text = "\(String(transaction.gasPrice.quantity, radix: 10).weiToGweiStr()) gwei"

        txFeeInfo.text = "Max TX Fee:"
        txFee.text = "\(String(transaction.gasPrice.quantity * transaction.gas.quantity, radix: 10).weiToEthStr()) ETH"

        nonceInfo.text = "Nonce:"
        nonce.text = "???"
    }

    private func fillAsyncInfo() {
        loadingView.startLoading()

        let from = transaction.from.address

        let web3 = Web3(rpcURL: transaction.rpcUrl.url)

        let balancePromise: Promise<BigUInt>
        if let token = transaction.currency {
            let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: try? EthereumAddress(hex: token.addressString, eip55: false))

            // Get the balance for this token
            balancePromise = firstly {
                contract.balanceOf(address: from).call()
            }.then { balance in
                unwrap(balance["_balance"] as? BigUInt)
            }
        } else {
            // Get ETH balance
            balancePromise = firstly {
                web3.eth.getBalance(address: from, block: .latest)
            }.then { balance in
                return Promise { seal in
                    seal.fulfill(balance.quantity)
                }
            }
        }

        firstly {
            when(fulfilled: balancePromise, web3.eth.getTransactionCount(address: from, block: .latest))
        }.done { balance, nonce in
            self.balance.text = self.getBalanceText(balance: balance)
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

    private func getBalanceText(balance: BigUInt) -> String {
        let currencySymbol = transaction.currency?.symbol ?? "ETH"

        let amountDecimal = BigUDecimal(balance)
        let decimals = transaction.currency?.decimals ?? 18

        return "\((amountDecimal / BigUDecimal(BigUInt(10).power(decimals))).description) \(currencySymbol)"
    }

    // MARK: - Actions

    @objc private func sendButtonClicked() {
        loadingView.startLoading()

        let tx = EthereumTransaction(
            nonce: nonceQuantity,
            gasPrice: transaction.gasPrice,
            gas: transaction.gas,
            to: transaction.to,
            value: transaction.amount
        )
        let web3 = Web3(rpcURL: transaction.rpcUrl.url)

        firstly {
            try self.transaction.from.signTransaction(tx, chainId: EthereumQuantity(integerLiteral: UInt64(transaction.rpcUrl.chainId))).promise
        }.then { tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { txHash in
            let c = UIStoryboard(name: "TransactionConfirmation", bundle: nil)
                .instantiateViewController(withIdentifier: "TransactionConfirmationResult")
                as? TransactionConfirmationResultViewController

            c >>- curry(self.showResult)(txHash)

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

    let from: EncryptedAccount
    let to: EthereumAddress
    let amount: EthereumQuantity
    let gas: EthereumQuantity
    let gasPrice: EthereumQuantity
    let currency: ERC20TrackedToken?

    let rpcUrl: RPCUrl
}
