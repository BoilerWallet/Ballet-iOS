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

        // Test button
        testButton.setTitleColor(Colors.accentColor, for: .normal)
        testButton.setTitle("Test", for: .normal)
        testButton.addTarget(self, action: #selector(testButtonClicked), for: .touchUpInside)

        // Stuff
        blockiesImageView.layer.cornerRadius = blockiesImageView.bounds.width / 2
        blockiesImageView.layer.masksToBounds = true
        nameLabel.setupTitleLabel()
        extraInfoLabel.setupSubTitleLabel()

        // Save button
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        saveButton.setBackgroundColor(Colors.accentColor)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func testButtonClicked() {
        guard let text = addressInputTextField.text, let address = try? EthereumAddress(hex: text, eip55: true) else {
            addressInputTextField.detail = "Checksum didn't match"
            addressInputTextField.isErrorRevealed = true
            return
        }
        addressInputTextField.isErrorRevealed = false

        let web3 = RPC.activeWeb3

        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: address)

        // Get info for contract
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
