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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressInputTextField: ErrorTextField!
    @IBOutlet weak var nameInputTextField: ErrorTextField!
    @IBOutlet weak var testButton: MDCFlatButton!

    @IBOutlet weak var blockiesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!

    @IBOutlet weak var saveButton: MDCRaisedButton!

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

        nameInputTextField.placeholder = "ERC20 contract name"
        nameInputTextField.setupProjectDefault()
        nameInputTextField.autocorrectionType = .no
        nameInputTextField.returnKeyType = .done
        nameInputTextField.delegate = self
        nameInputTextField.detailColor = Color.red.base

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
    }

    // MARK: - Actions

    @objc private func testButtonClicked() {
        blockiesImageView.image = nil
        nameLabel.text = ""
        extraInfoLabel.text = ""

        guard let text = addressInputTextField.text, let address = try? EthereumAddress(hex: text, eip55: true) else {
            addressInputTextField.detail = "Checksum didn't match"
            addressInputTextField.isErrorRevealed = true
            return
        }
        addressInputTextField.isErrorRevealed = false

        let web3 = RPC.activeWeb3

        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: address)

        // Get info for contract
        firstly {
            contract.name().call()
        }.then { name in
            unwrap(name["_name"] as? String)
        }.done { [weak self] name in
            self?.nameLabel.text = name
            self?.nameInputTextField.text = name
        }.catch { [weak self] error in
            self?.nameLabel.text = "*No name*"
        }.finally {
            /*
            firstly {
                contract.symbol().call()
            }.then { symbol in
                unwrap(symbol["_symbol"] as? String)
            }.done { [weak self] symbol in
                self?.nameLabel.text = "\(self?.nameLabel.text ?? "") (\(symbol))"
                self?.nameInputTextField.text = "\(self?.nameInputTextField.text ?? "") (\(symbol))"
            }.catch { [weak self] error in
                self?.nameLabel.text = "\(self?.nameLabel.text ?? "") (*No symbol*)"
                self?.nameInputTextField.text = "\(self?.nameInputTextField.text ?? "") (*No symbol*)"
            }*/
        }

        firstly {
            contract.totalSupply().call()
        }.then { totalSupply in
            unwrap(totalSupply["_totalSupply"] as? BigUInt)
        }.done { [weak self] totalSupply in
            self?.blockiesImageView.setBlockies(with: address.hex(eip55: false))
            self?.extraInfoLabel.text = "Total supply: \(totalSupply)"
        }.catch { [weak self] error in
            // TODO: Handle error case
            print(error)
        }

        guard let t = nameInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !t else {
            nameInputTextField.detail = "Please enter a name"
            nameInputTextField.isErrorRevealed = true
            return
        }
        nameInputTextField.isErrorRevealed = false
    }

    @objc private func saveButtonClicked() {

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
