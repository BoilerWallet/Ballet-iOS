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
import PromiseKit
import Runes

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
    @IBOutlet weak var currencyButton: MDCFlatButton!
    @IBOutlet weak var currencyButtonLabel: UILabel!

    @IBOutlet weak var gasTextField: ErrorTextField!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var feeSlider: MDCSlider!
    @IBOutlet weak var feeInfoLabel: UILabel!

    @IBOutlet weak var sendTransactionButton: MDCRaisedButton!

    private var currentGasPrice: ETHGasStationGasPrice?

    private var selectedAccount: EncryptedAccount?

    private var selectedCurrency: ERC20TrackedToken?

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

        let qrButton = IconButton(image: UIImage(named: "ic_qrcode")?.withRenderingMode(.alwaysTemplate), tintColor: Colors.lightPrimaryTextColor)
        qrButton.addTarget(self, action: #selector(qrButtonClicked), for: .touchUpInside)

        navigationItem.rightViews = [qrButton]
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
        currencyButton.setTitleColor(Colors.accentColor, for: .normal)
        currencyButton.addTarget(self, action: #selector(currencyButtonClicked), for: .touchUpInside)
        currencyButtonLabel.setupTitleLabel()
        currencyButtonLabel.textAlignment = .center
        currencyButtonLabel.textColor = Colors.accentColor
        currencyButtonLabel.text = "ETH"

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

        gasTextField.placeholder = "Gas Limit"
        gasTextField.setupProjectDefault()
        gasTextField.autocorrectionType = .no
        gasTextField.keyboardType = .numberPad
        gasTextField.returnKeyType = .done
        gasTextField.delegate = self
        gasTextField.text = selectedCurrency == nil ? "21000" : "200000"

        feeLabel.setupSubTitleLabel()
        feeLabel.text = "FEE"

        feeInfoLabel.setupSubTitleLabel()
        feeInfoLabel.textAlignment = .right
        feeInfoLabel.text = "N/A - ?"

        feeSlider.color = Colors.accentColor

        feeSlider.isEnabled = false

        feeSlider.addTarget(self, action: #selector(feeSliderChanged(sender:)), for: .valueChanged)

        let realm = try? Realm()
        firstly {
            unwrap(realm?.objects(RPCUrl.self).filter("isActive == true").first)
        }.then { url in
            ETHGasStation.getGasPrice(for: url)
        }.done { gasPrice in
            self.currentGasPrice = gasPrice

            self.feeSlider.minimumValue = CGFloat(gasPrice.safeLow)
            self.feeSlider.maximumValue = CGFloat(gasPrice.fastest)
            self.feeSlider.isEnabled = true

            self.feeSlider.setValue(CGFloat(gasPrice.average), animated: true)
            self.feeSliderChanged(sender: self.feeSlider)
        }.catch { error in
            print(error)
            let details = "Something went wrong. Please restart the app and file an issue on Github if it happens repeatedly."
            Dialog().details(details).positive("OK", handler: nil).show(self)
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

    private func selectAccount(account: EncryptedAccount) {
        self.selectedAccount = account

        fromSelectedBlockiesImage.setBlockies(with: account.address.hex(eip55: false))
        fromSelectedName.text = account.account.name
        fromSelectedAddress.text = account.address.hex(eip55: true)
    }

    private func selectCurrency(trackedToken: ERC20TrackedToken?) {
        selectedCurrency = trackedToken
        if let t = trackedToken {
            currencyButtonLabel.text = t.symbol
        } else {
            currencyButtonLabel.text = "ETH"
        }
    }

    // MARK: - Actions

    @objc private func qrButtonClicked() {
        guard let controller = UIStoryboard(name: "QRScannerController", bundle: nil).instantiateInitialViewController() as? QRScannerController else {
            return
        }
        controller.completion = { str in
            let error: (_ str: String) -> Void = { str in
                Dialog().details(str)
                    .positive("OK", handler: nil)
                    .show(self)
            }

            let url = URL(string: str)
            guard url?.scheme == "ethereum" else {
                error("Bad QR code")
                return
            }

            var str = str

            str = str.deletingPrefix("ethereum:")

            let payable: String
            let chainId: String?
            if let atIndex = str.index(of: "@") {
                payable = String(str[..<atIndex])
                chainId = String(str[str.index(after: atIndex)..<(str.index(of: "/") ?? str.endIndex)])
            } else {
                payable = str
                chainId = nil
            }

            let prefix: String?
            let addressString: String
            if let dashIndex = payable.index(of: "-") {
                prefix = String(payable[..<dashIndex])
                addressString = String(payable[payable.index(after: dashIndex)...])
            } else {
                prefix = nil
                addressString = payable
            }

            // Check uri
            if let p = prefix, p != "pay" {
                // URI malformed
                error("Bad QR code")
                return
            }
            guard let address = try? EthereumAddress(hex: addressString, eip55: true) else {
                // Checksum failed
                error("Address checksum failed")
                return
            }
            if let c = chainId, c != String(RPC.activeUrl.chainId) {
                // Wrong network
                error("You are on the wrong network for this QR code. Switch network in the settings page.")
                return
            }

            // All correct. Set address.
            self.toTextField.text = address.hex(eip55: true)
        }

        present(controller, animated: true, completion: nil)
    }

    @objc private func currencyButtonClicked() {
        guard let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "TokenTrackerTableViewController") as? SettingsTokenTrackerViewController else {
            return
        }
        controller.forSelecting = true
        controller.showEth = true
        controller.tokenSelected = { [weak self] token in
            controller.dismiss(animated: true, completion: nil)
            self?.selectCurrency(trackedToken: token)
        }

        PopUpController.instantiate(from: self, with: controller)
    }

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

        let defaultGas: UInt = selectedCurrency == nil ? 21000 : 200000
        let gas = (gasTextField.text >>- UInt.init) ?? defaultGas
        let eth = (sender.value * CGFloat(gas)) / 1_000_000_000
        info += " - \((eth * 1_000_000).rounded() / 1_000_000) ETH"

        feeInfoLabel.text = info
    }

    @objc private func sendTransactionButtonClicked() {
        sendTransactionButton.isEnabled = false
        defer {
            sendTransactionButton.isEnabled = true
        }

        let url = RPC.activeUrl

        guard let selectedFrom = selectedAccount else {
            Dialog().details("Please select a 'from' account").positive("OK", handler: nil).show(self)
            return
        }

        guard let to = toTextField.text, let toAddress = try? EthereumAddress(hex: to, eip55: true) else {
            toTextField.detail = "Checksum didn't match"
            toTextField.isErrorRevealed = true
            return
        }
        toTextField.isErrorRevealed = false

        guard let amountStr = amountTextField.text?.replacingOccurrences(of: ",", with: "."), var amount = BigUDecimal(string: amountStr) else {
            amountTextField.detail = "Please type in a value"
            amountTextField.isErrorRevealed = true
            return
        }
        amountTextField.isErrorRevealed = false

        // Convert amount to smallest unit
        amount = amount * BigUDecimal(BigUInt(10).power(selectedCurrency?.decimals ?? 18))
        amount = amount.normalizeZeros()

        // Make sure we don't have decimal places
        // Make sure we don't have more decimals than allowed. This would cause problems later
        guard amount.exponent >= 0 else {
            amountTextField.detail = "Too many decimals. Max: \(selectedCurrency?.decimals ?? 18)"
            amountTextField.isErrorRevealed = true
            return
        }
        amountTextField.isErrorRevealed = false

        // Create BigUInt from the BigUDecimal
        let amountBigUInt = amount.significand * BigUInt(10).power(amount.exponent)

        guard let gasLimitStr = gasTextField.text, let gasLimit = UInt(gasLimitStr) else {
            gasTextField.detail = "Please type in a value"
            gasTextField.isErrorRevealed = true
            return
        }
        gasTextField.isErrorRevealed = false

        guard feeSlider.isEnabled else {
            Dialog().details("Could not estimate a fee. Please restart the app.").positive("OK", handler: nil).show(self)
            return
        }

        let gasPrice = BigUInt(integerLiteral: UInt64(feeSlider.value * pow(10, 9)))

        let tx = PreparedTransaction(
            from: selectedFrom,
            to: toAddress,
            amount: EthereumQuantity(quantity: amountBigUInt),
            gas: EthereumQuantity(quantity: BigUInt(gasLimit)),
            gasPrice: EthereumQuantity(quantity: gasPrice),
            currency: selectedCurrency,
            rpcUrl: url
        )

        guard let controller = UIStoryboard(name: "TransactionConfirmation", bundle: nil).instantiateInitialViewController() as? TransactionConfirmationViewController else {
            return
        }
        controller.transaction = tx
        controller.completion = {
            self.fromSelectedBlockiesImage.image = nil
            self.fromSelectedName.text = ""
            self.fromSelectedAddress.text = ""
            self.selectedAccount = nil

            self.toTextField.text = ""
            self.amountTextField.text = ""
        }

        PopUpController.instantiate(from: self, with: controller)
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
        // Ethereum Amount. e.g.: n digits and up to 18 decimal digits for ETH and "decimals" digits for ERC20 tokens
        if textField === amountTextField || textField === gasTextField {
            if string.count == 0 {
                return true
            }
            do {
                if let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                    let expression: String
                    if textField === amountTextField {
                        expression = "^([0-9]+)([,\\.]([0-9]{1,\(selectedCurrency?.decimals ?? 18)})?)?$"
                    } else if textField === gasTextField {
                        expression = "^[1-9][0-9]*$"
                    } else {
                        expression = ""
                    }
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
