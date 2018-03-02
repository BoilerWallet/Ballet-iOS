//
//  SendViewController.swift
//  Ballet
//
//  Created by Koray Koska on 19.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import DropDown
import RealmSwift
import Web3
import BlockiesSwift
import MaterialComponents.MaterialButtons
import Material
import BigInt
import MaterialComponents.MaterialSlider
import MaterialComponents.MaterialSnackbar

class SendViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromSelectedView: DashedBorderView!
    @IBOutlet weak var fromSelectedBlockiesImage: UIImageView!
    @IBOutlet weak var fromSelectedName: UILabel!
    @IBOutlet weak var fromSelectedAddress: UILabel!

    @IBOutlet weak var selectFromAddressButton: MDCFlatButton!

    @IBOutlet weak var toTextField: ErrorTextField!

    @IBOutlet weak var amountTextField: ErrorTextField!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var feeSlider: MDCSlider!
    @IBOutlet weak var feeInfoLabel: UILabel!

    @IBOutlet weak var sendTransactionButton: MDCRaisedButton!

    private var currentGasPrice: ETHGasStationGasPrice?

    private var selectedAccount: Account?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupFee()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        setupToolbar()
        view.backgroundColor = Colors.background

        setupFrom()
        setupTo()
        setupAmount()
        setupSend()
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Send"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
    }

    private func setupFrom() {
        fromLabel.setupTitleLabel()
        fromLabel.text = "FROM"

        fromSelectedView.borderColor = Colors.darkSecondaryTextColor
        fromSelectedView.applyDashBorder()
        fromSelectedView.layer.cornerRadius = 5
        fromSelectedView.layer.masksToBounds = true

        fromSelectedBlockiesImage.layer.cornerRadius = fromSelectedBlockiesImage.bounds.width / 2
        fromSelectedBlockiesImage.layer.masksToBounds = true

        fromSelectedName.setupTitleLabel()
        fromSelectedName.text = ""
        fromSelectedAddress.setupSubTitleLabel()
        fromSelectedAddress.text = ""

        // Select from button
        selectFromAddressButton.setTitleColor(Colors.accentColor, for: .normal)
        selectFromAddressButton.setTitle("Select Account", for: .normal)
        selectFromAddressButton.addTarget(self, action: #selector(selectFromAddressButtonClicked), for: .touchUpInside)
    }

    private func setupTo() {
        toTextField.placeholder = "Receiver Address"
        toTextField.setupProjectDefault()
        toTextField.autocorrectionType = .no
        toTextField.returnKeyType = .done
        toTextField.delegate = self

        toTextField.detailColor = Color.red.base
    }

    private func setupAmount() {
        amountLabel.setupSubTitleLabel()
        amountLabel.text = "ETH"

        amountTextField.placeholder = "Amount"
        amountTextField.setupProjectDefault()
        amountTextField.autocorrectionType = .no
        amountTextField.keyboardType = .decimalPad
        amountTextField.returnKeyType = .done
        amountTextField.delegate = self

        amountTextField.detailColor = Color.red.base
    }

    private func setupFee() {
        currentGasPrice = nil

        feeLabel.setupSubTitleLabel()
        feeLabel.text = "FEE"

        feeInfoLabel.setupSubTitleLabel()
        feeInfoLabel.textAlignment = .right
        feeInfoLabel.text = "N/A - ?"

        feeSlider.color = Colors.accentColor

        feeSlider.isEnabled = false

        feeSlider.addTarget(self, action: #selector(feeSliderChanged(sender:)), for: .valueChanged)

        if let u = try? Realm().objects(RPCUrl.self).filter("isActive == true").first, let url = u {
            if url.isMainnet {
                ETHGasStation.getGasPrice { [weak self] success, gasPrice in
                    guard let gasPrice = gasPrice, success else {
                        if let s = self {
                            let details = "Something went wrong. Please restart the app and file an issue on Github if it happens repeatedly."
                            Dialog().details(details).positive("OK", handler: nil).show(s)
                        }
                        return
                    }
                    self?.currentGasPrice = gasPrice

                    self?.feeSlider.minimumValue = CGFloat(gasPrice.safeLow)
                    self?.feeSlider.maximumValue = CGFloat(gasPrice.fastest)
                    self?.feeSlider.isEnabled = true

                    self?.feeSlider.setValue(CGFloat(gasPrice.average), animated: true)
                    if let s = self {
                        s.feeSliderChanged(sender: s.feeSlider)
                    }
                }
            } else {
                feeSlider.minimumValue = 0
                feeSlider.maximumValue = 200
                feeSlider.isEnabled = true

                feeSlider.setValue(21, animated: true)
                feeSliderChanged(sender: feeSlider)
            }
        }
    }

    private func setupSend() {
        sendTransactionButton.setTitle("Send", for: .normal)
        sendTransactionButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        sendTransactionButton.setBackgroundColor(Colors.accentColor)
        sendTransactionButton.addTarget(self, action: #selector(sendTransactionButtonClicked), for: .touchUpInside)
    }

    // MARK: - Helper functions

    private func showGeneralError() {
        Dialog().details("An error occured. Please try again later and file an issue on Github.")
            .positive("OK", handler: nil)
            .show(self)
    }

    private func resetInput() {
        fromSelectedName.text = ""
        fromSelectedAddress.text = ""
        fromSelectedBlockiesImage.image = nil
        selectedAccount = nil

        toTextField.text = ""

        amountTextField.text = ""
    }

    private func selectAccount(account: Account) {
        self.selectedAccount = account

        try? fromSelectedBlockiesImage.setBlockies(with: account.ethereumPrivateKey().address.hex(eip55: false))
        fromSelectedName.text = account.name
        try? fromSelectedAddress.text = account.ethereumPrivateKey().address.hex(eip55: true)
    }

    private func sendTransaction(from: RPCUrl, transaction: EthereumTransaction) {
        Web3(rpcURL: from.url).eth.sendRawTransaction(transaction: transaction) { [weak self] response in
            DispatchQueue.main.sync {
                guard let resp = response.rpcResponse?.result, response.status == .ok else {
                    self?.showGeneralError()
                    return
                }

                let snack = MDCSnackbarMessage()
                snack.text = "Your transaction was sent successfully."
                let action = MDCSnackbarMessageAction()
                action.handler = {
                    if let e = from.etherscanBaseUrl, let u = URL(string: "\(e)/tx/\(resp.hex())") {
                        UIApplication.shared.openURL(u)
                    }
                }
                action.title = "View TX"
                snack.action = action
                snack.buttonTextColor = Colors.accentColor

                MDCSnackbarManager.show(snack)

                self?.resetInput()
            }
        }
    }

    // MARK: - Actions

    @objc private func selectFromAddressButtonClicked() {
        guard let controller = UIStoryboard(name: "SelectAccount", bundle: nil).instantiateInitialViewController() as? SelectAccountCollectionViewController else {
            return
        }

        controller.completion = { [weak self] account in
            self?.selectAccount(account: account)
        }

        PopUpController.instantiate(from: self, with: controller)
    }

    @objc private func feeSliderChanged(sender: MDCSlider) {
        guard let gasPrice = currentGasPrice else {
            feeInfoLabel.text = "\(Int(sender.value.rounded())) gwei"
            return
        }

        var info: String = ""

        var minutes: Double
        if sender.value >= CGFloat(gasPrice.fastest) {
            minutes = gasPrice.fastestWait
            info += "Fastest, "
        } else if sender.value >= CGFloat(gasPrice.fast) {
            minutes = gasPrice.fastWait
            info += "Fast, "
        } else if sender.value >= CGFloat(gasPrice.average) {
            minutes = gasPrice.avgWait
            info += "Average, "
        } else {
            minutes = gasPrice.safeLowWait
            info += "Slower, "
        }

        if minutes <= 1 {
            info += "\(Int((minutes * 60).rounded())) sec"
        } else {
            info += "\(Int((minutes + 0.5).rounded())) min"
        }

        let eth = (sender.value * 21000) / 1_000_000_000
        info += " - \((eth * 1_000_000).rounded() / 1_000_000) ETH"

        feeInfoLabel.text = info
    }

    @objc private func sendTransactionButtonClicked() {
        sendTransactionButton.isEnabled = false
        defer {
            sendTransactionButton.isEnabled = true
        }

        guard let u = try? Realm().objects(RPCUrl.self).filter("isActive == true").first, let url = u else {
            Dialog().details("Could not detect your selected chain. Please check the settings.")
                .positive("OK", handler: nil)
                .show(self)
            return
        }

        guard let selectedFrom = selectedAccount, let priv = try? selectedFrom.ethereumPrivateKey() else {
            Dialog().details("Please select a 'from' account").positive("OK", handler: nil).show(self)
            return
        }

        guard let to = toTextField.text, let toAddress = try? EthereumAddress(hex: to, eip55: true) else {
            toTextField.detail = "Checksum didn't match"
            toTextField.isErrorRevealed = true
            return
        }
        toTextField.isErrorRevealed = false

        guard let amountStr = amountTextField.text, let amount = amountStr.ethToWei() else {
            amountTextField.detail = "Please type in a value"
            amountTextField.isErrorRevealed = true
            return
        }
        amountTextField.isErrorRevealed = false

        guard feeSlider.isEnabled else {
            Dialog().details("Could not estimate a fee. Please restart the app.").positive("OK", handler: nil).show(self)
            return
        }

        let gasPrice = BigUInt(integerLiteral: UInt64(feeSlider.value * pow(10, 9)))

        Web3(rpcURL: url.url).eth.getTransactionCount(address: priv.address, block: .latest) { [weak self] response in
            DispatchQueue.main.sync {
                guard let nonce = response.rpcResponse?.result, response.status == .ok else {
                    self?.showGeneralError()
                    return
                }

                var tx = EthereumTransaction(
                    nonce: nonce,
                    gasPrice: EthereumQuantity(quantity: gasPrice),
                    gasLimit: 21000,
                    to: toAddress,
                    value: EthereumQuantity(quantity: amount),
                    chainId: EthereumQuantity(integerLiteral: UInt64(url.chainId))
                )
                do {
                    try tx.sign(with: selectedFrom.ethereumPrivateKey())
                } catch {
                    self?.showGeneralError()
                    return
                }

                self?.sendTransaction(from: url, transaction: tx)
            }
        }
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

extension SendViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === toTextField {
            textField.resignFirstResponder()

            return false
        } else if textField === amountTextField {
            textField.resignFirstResponder()

            return false
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ethereum Amount. e.g.: n digits and up to 18 decimal digits
        if textField === amountTextField {
            if string.count == 0 {
                return true
            }
            do {
                if let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                    let expression = "^([0-9]+)?(\\.([0-9]{1,18})?)?$"
                    let regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
                    let numberOfMatches = regex.numberOfMatches(in: newString, options: [], range: NSRange(location: 0, length: newString.count))
                    if numberOfMatches == 0 {
                        return false
                    }
                }
            }
            catch {
            }
        }

        return true
    }
}
