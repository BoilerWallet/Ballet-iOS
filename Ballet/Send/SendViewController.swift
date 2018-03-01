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

class SendViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromSelectedView: DashedBorderView!
    @IBOutlet weak var fromSelectedBlockiesImage: UIImageView!
    @IBOutlet weak var fromSelectedName: UILabel!
    @IBOutlet weak var fromSelectedAddress: UILabel!

    @IBOutlet weak var selectFromAddressButton: MDCFlatButton!

    @IBOutlet weak var toTextField: TextField!

    @IBOutlet weak var amountTextField: TextField!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var sendTransactionButton: MDCRaisedButton!

    private var selectedAccount: Account?

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
        fromLabel.text = "From"

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
    }

    private func setupSend() {
        sendTransactionButton.setTitle("Send", for: .normal)
        sendTransactionButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        sendTransactionButton.setBackgroundColor(Colors.accentColor)
        sendTransactionButton.addTarget(self, action: #selector(sendTransactionButtonClicked), for: .touchUpInside)
    }

    // MARK: - Helper functions

    private func selectAccount(account: Account) {
        self.selectedAccount = account

        try? fromSelectedBlockiesImage.setBlockies(with: account.ethereumPrivateKey().address.hex(eip55: false))
        fromSelectedName.text = account.name
        try? fromSelectedAddress.text = account.ethereumPrivateKey().address.hex(eip55: true)
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

    @objc private func sendTransactionButtonClicked() {

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
}
