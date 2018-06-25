//
//  SettingsTrackNewTokenViewController.swift
//  Ballet
//
//  Created by Koray Koska on 24.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MaterialButtons
import Web3

class SettingsTrackNewTokenViewController: UIViewController {

    // MARK: - Properties

    var completion: ((_ trackedToken: ERC20TrackedToken) -> Void)?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressInputTextField: ErrorTextField!
    @IBOutlet weak var nameInputTextField: ErrorTextField!
    @IBOutlet weak var testButton: MDCFlatButton!

    @IBOutlet weak var blockiesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!

    @IBOutlet weak var saveButton: MDCRaisedButton!

    private var resultAddress: EthereumAddress?

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
        // Title
        titleLabel.setupSubTitleLabelWithSize(size: 22)
        titleLabel.textAlignment = .center
        titleLabel.text = "Track new ERC20 Token"

        // Input
        addressInputTextField.placeholder = "ERC20 contract address"
        addressInputTextField.setupProjectDefault()
        addressInputTextField.autocorrectionType = .no
        addressInputTextField.returnKeyType = .done
        addressInputTextField.delegate = self
        addressInputTextField.detailColor = Color.red.base
        addressInputTextField.detail = "Checksum didn't match"

        nameInputTextField.placeholder = "ERC20 contract name"
        nameInputTextField.setupProjectDefault()
        nameInputTextField.autocorrectionType = .no
        nameInputTextField.returnKeyType = .done
        nameInputTextField.delegate = self
        nameInputTextField.detailColor = Color.red.base
        nameInputTextField.detail = "Enter a name"

        // Test button
        testButton.setTitleColor(Colors.accentColor, for: .normal)
        testButton.setTitle("Test", for: .normal)
        testButton.addTarget(self, action: #selector(testButtonClicked), for: .touchUpInside)

        // Stuff
        blockiesImageView.layer.cornerRadius = blockiesImageView.bounds.width / 2
        blockiesImageView.layer.masksToBounds = true
        nameLabel.setupTitleLabel()
        nameLabel.text = ""
        extraInfoLabel.setupSubTitleLabel()
        extraInfoLabel.text = ""

        // Save button
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        saveButton.setBackgroundColor(Colors.accentColor)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.setBackgroundColor(Color.gray, for: .disabled)
    }

    // MARK: - Actions

    @objc private func testButtonClicked() {
        testInput().done { [weak self] result in
            self?.addressInputTextField.isErrorRevealed = false
            self?.nameInputTextField.isErrorRevealed = false

            let nameText = "\(result.name ?? "*No name*") (\(result.symbol ?? "*No symbol*"))"
            self?.nameInputTextField.text = nameText
            self?.nameLabel.text = nameText

            self?.blockiesImageView.setBlockies(with: result.address.hex(eip55: false))

            self?.extraInfoLabel.text = "Total supply: \(result.totalSupply)"

            self?.saveButton.isEnabled = true
            self?.resultAddress = result.address
        }.catch { [weak self] error in
            if let e = error as? EthereumAddress.Error, e == .checksumWrong {
                self?.addressInputTextField.isErrorRevealed = true
            } else if let e = self?.nameInputTextField.text?.isEmpty, !e {
                self?.nameInputTextField.isErrorRevealed = true
            } else if self?.nameInputTextField.text == nil {
                self?.nameInputTextField.isErrorRevealed = true
            } else {
                if let s = self {
                    Dialog().details("Can't fetch token information. Are you sure your given address is an ERC20 contract address?").positive("OK", handler: nil).show(s)
                }
            }
        }
    }

    @objc private func saveButtonClicked() {
        guard let address = resultAddress else {
            return
        }
        guard let name = nameInputTextField.text, !name.isEmpty else {
            nameInputTextField.isErrorRevealed = true
            return
        }
        nameInputTextField.isErrorRevealed = false

        let trackedToken = ERC20TrackedToken()
        trackedToken.addressString = address.hex(eip55: true)
        trackedToken.name = name
        trackedToken.rpcUrlID = RPC.activeUrl.rpcUrlID

        dismiss(animated: true, completion: nil)

        completion?(trackedToken)
    }

    // MARK: - Helpers

    private struct TestInputResult {

        let address: EthereumAddress
        let name: String?
        let symbol: String?
        let totalSupply: BigUInt
    }

    private func testInput() -> Promise<TestInputResult> {
        guard let text = addressInputTextField.text, let address = try? EthereumAddress(hex: text, eip55: true) else {
            return Promise { seal in
                seal.reject(EthereumAddress.Error.checksumWrong)
            }
        }

        let web3 = RPC.activeWeb3

        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: address)

        let addressGuarantee = Guarantee { seal in
            seal(address)
        }

        // Get info for contract
        return firstly {
            when(fulfilled: contract.name().call(), contract.symbol().call(), contract.totalSupply().call())
        }.then { name, symbol, totalSupply in
            return when(fulfilled: addressGuarantee, optionalUnwrap(name["_name"] as? String), optionalUnwrap(symbol["_symbol"] as? String), unwrap(totalSupply["_totalSupply"] as? BigUInt))
        }.then { address, name, symbol, totalSupply in
            return Promise { seal in
                seal.fulfill(TestInputResult(address: address, name: name, symbol: symbol, totalSupply: totalSupply))
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

extension SettingsTrackNewTokenViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === addressInputTextField {
            textField.resignFirstResponder()

            return false
        }

        return true
    }
}
