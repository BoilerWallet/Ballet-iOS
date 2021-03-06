//
//  AddAccountViewController.swift
//  Ballet
//
//  Created by Koray Koska on 19.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Web3
import Cartography
import BlockiesSwift
import AlamofireImage
import MaterialComponents.MaterialButtons

class AddAccountViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var loadingView: LoadingView!

    @IBOutlet weak var selectBlockiesLabel: UILabel!

    @IBOutlet weak var blockiesView: BlockiesSelectionView!

    @IBOutlet weak var reloadBlockiesButton: MDCFlatButton!

    @IBOutlet weak var accountNameTextField: TextField!

    @IBOutlet weak var createAccountButton: MDCRaisedButton!

    private var generatedPrivateKeys: [String: EthereumPrivateKey] = [:]
    private var selectedAddress: EthereumAddress?

    /// May be called in a background thread. Be careful.
    var completion: ((_ selectedAddress: EthereumPrivateKey, _ name: String) -> Void)?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        generateAccounts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        // Transparent background
        view.backgroundColor = UIColor.clear
        view.isOpaque = false

        // Label
        selectBlockiesLabel.setupSubTitleLabelWithSize(size: 22)
        selectBlockiesLabel.textAlignment = .center
        selectBlockiesLabel.text = "Select your favourite new Account!"

        // Blockies View
        blockiesView.completion = { [weak self] address in
            self?.selectedAddress = address
        }

        // Reload button
        reloadBlockiesButton.setTitleColor(Colors.accentColor, for: .normal)
        reloadBlockiesButton.setTitle("Reload", for: .normal)
        reloadBlockiesButton.addTarget(self, action: #selector(reloadBlockiesButtonClicked), for: .touchUpInside)

        // Account name
        accountNameTextField.placeholder = "Your account's new name"
        accountNameTextField.setupProjectDefault()
        accountNameTextField.autocorrectionType = .no
        accountNameTextField.returnKeyType = .done
        accountNameTextField.delegate = self
        // UI test specific
        accountNameTextField.accessibilityIdentifier = "account_name"

        // Create
        createAccountButton.setTitle("Create", for: .normal)
        createAccountButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        createAccountButton.setBackgroundColor(Colors.accentColor)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonClicked), for: .touchUpInside)

        // Motion
        isMotionEnabled = true
    }

    private func generateAccounts(completion: (() -> Void)? = nil) {
        // Start loading animation
        blockiesView.loadingView.startLoading()

        DispatchQueue(label: "AddAccountPrivateKeyGeneration").async { [weak self] in
            var accounts = [EthereumPrivateKey]()
            for _ in 0..<6 {
                try? accounts.append(EthereumPrivateKey())
            }
            guard accounts.count == 6 else {
                // TODO: Error handling
                return
            }
            // Save the keys temprarily
            for p in accounts {
                self?.generatedPrivateKeys[p.address.hex(eip55: false)] = p
            }
            DispatchQueue.main.sync {
                self?.blockiesView.setAccounts(accounts: accounts.map({ return $0.address })) { [weak self] in
                    self?.blockiesView.loadingView.stopLoading()
                    completion?()
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func reloadBlockiesButtonClicked() {
        reloadBlockiesButton.setEnabled(false, animated: true)
        generateAccounts { [weak self] in
            self?.reloadBlockiesButton.setEnabled(true, animated: true)
        }
    }

    @objc private func createAccountButtonClicked() {
        loadingView.startLoading()
        createAccountButton.isEnabled = false

        guard let selected = selectedAddress, let privateKey = generatedPrivateKeys[selected.hex(eip55: false)], let name = accountNameTextField.text, !name.isEmpty else {
            Dialog().details("Please select an account and a name").positive("OK", handler: nil).show(self)

            loadingView.stopLoading()
            createAccountButton.isEnabled = true

            return
        }

        let comp = DispatchWorkItem {
            self.completion?(privateKey, name)
        }

        DispatchQueue.global().async {
            comp.perform()
        }

        comp.notify(queue: DispatchQueue.main) {
            self.dismiss(animated: true, completion: nil)
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

extension AddAccountViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === accountNameTextField {
            textField.resignFirstResponder()

            return false
        }

        return true
    }
}
