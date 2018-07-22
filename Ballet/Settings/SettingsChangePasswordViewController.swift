//
//  SettingsChangePasswordViewController.swift
//  Ballet
//
//  Created by Koray Koska on 22.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MaterialButtons
import PromiseKit
import Keystore
import Web3
import RealmSwift

class SettingsChangePasswordViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var loadingView: LoadingView!

    @IBOutlet weak var saveButton: MDCRaisedButton!

    @IBOutlet weak var oldPasswordTextField: ErrorTextField!
    @IBOutlet weak var newPasswordTextField: ErrorTextField!
    @IBOutlet weak var newPasswordConfirmationTextField: ErrorTextField!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fillUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _ = oldPasswordTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = Colors.background
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor

        setupTextFields()
        setupSaveButton()
    }

    private func setupTextFields() {
        setupTextField(
            textField: oldPasswordTextField,
            placeholder: "Current Password",
            detail: "Your password is wrong. Please try again.",
            editingTarget: #selector(passwordTextfieldChanged)
        )

        setupTextField(
            textField: newPasswordTextField,
            placeholder: "New Password",
            detail: "Password is too weak. At least 8 characters.",
            editingTarget: #selector(passwordTextfieldChanged)
        )
        setupTextField(
            textField: newPasswordConfirmationTextField,
            placeholder: "Confirm New Password",
            detail: "Your passwords didn't match",
            editingTarget: #selector(passwordTextfieldChanged)
        )
    }

    private func setupTextField(textField: ErrorTextField, placeholder: String, detail: String, editingTarget: Selector) {
        textField.placeholder = placeholder
        textField.setupProjectDefault()
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.delegate = self
        textField.detailColor = Color.red.base
        textField.detail = detail
        textField.addTarget(self, action: editingTarget, for: .editingChanged)
    }

    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        saveButton.setBackgroundColor(Colors.accentColor)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.setBackgroundColor(Color.gray, for: .disabled)
    }

    private func fillUI() {
        navigationItem.titleLabel.text = "Change Password"
    }

    // MARK: - Helpers

    private enum CheckPasswordError: Error {

        case internalError
        case passwordWrong
    }

    private func checkPassword(passwordData: Data, hash: [UInt8], salt: [UInt8]) -> Promise<Void> {
        return Promise { seal in
            DispatchQueue.global().async {
                guard let pHash = try? LoggedInUser.hashPassword([UInt8](passwordData), salt: salt) else {
                    // PROMISE
                    seal.reject(CheckPasswordError.internalError)
                    return
                }

                if pHash != hash {
                    // PROMISE
                    seal.reject(CheckPasswordError.passwordWrong)
                    return
                }

                // PROMISE
                seal.fulfill(())
            }
        }
    }

    private func changePassword(newPassword: String) -> Promise<Void> {
        let async = DispatchQueue.global()

        let decryptedPromises = LoggedInUser.shared.encryptedAccounts.map { $0.decryptedAccount() }

        return firstly {
            when(fulfilled: decryptedPromises)
        }.then(on: async) { decrypted -> Promise<[(account: Account, newKeystore: String)]> in
            var accounts: [(Account, String)] = []
            for acc in decrypted {
                let keystore = try Keystore(privateKey: acc.privateKey.rawPrivateKey, password: newPassword)
                guard let keystoreString = try String(data: JSONEncoder().encode(keystore), encoding: .utf8) else {
                    throw OptionalUnwrapError.optionalNil
                }
                let account = acc.account

                accounts.append((account, keystoreString))
            }

            return Promise { seal in
                seal.fulfill(accounts)
            }
        }.then(on: DispatchQueue.main) { accounts -> Promise<()> in
            try Realm().write {
                for a in accounts {
                    a.account.keystore = a.newKeystore
                }
            }
            return Promise { seal in
                seal.fulfill(())
            }
        }
    }

    // MARK: - Actions

    @objc private func passwordTextfieldChanged() {
        if let t1 = oldPasswordTextField.text?.isEmpty, !t1, let t2 = newPasswordTextField.text?.isEmpty, !t2, let t3 = newPasswordConfirmationTextField.text?.isEmpty, !t3 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    @objc private func saveButtonClicked() {
        // Start loading
        loadingView.startLoading()
        saveButton.isEnabled = false

        let finishLoading = {
            self.loadingView.stopLoading()
            self.saveButton.isEnabled = true
        }

        // Check inputs
        guard let oldPassword = oldPasswordTextField.text, let newPassword = newPasswordTextField.text, let newPasswordConfirmation = newPasswordConfirmationTextField.text else {
            finishLoading()
            return
        }

        guard newPassword.count >= 8 else {
            newPasswordTextField.isErrorRevealed = true
            return
        }
        newPasswordTextField.isErrorRevealed = false

        guard newPassword == newPasswordConfirmation else {
            newPasswordConfirmationTextField.isErrorRevealed = true
            return
        }
        newPasswordConfirmationTextField.isErrorRevealed = false

        guard let oldHash = (try? ConstantHolder.passwordHash?.dataWithHexString()) ?? nil, let oldSalt = (try? ConstantHolder.passwordSalt?.dataWithHexString()) ?? nil else {
            finishLoading()
            return
        }

        guard let oldPasswordData = oldPassword.data(using: .utf8) else {
            finishLoading()
            return
        }

        firstly {
            checkPassword(passwordData: oldPasswordData, hash: [UInt8](oldHash), salt: [UInt8](oldSalt))
        }.then {
            self.changePassword(newPassword: newPassword)
        }.done {
            // New Login must be simulated as the accounts changed.
        }.catch { error in
            if (error as? CheckPasswordError) == .passwordWrong {
                self.oldPasswordTextField.isErrorRevealed = true
                finishLoading()
            } else {
                // TODO: SOmething went wrong
                finishLoading()
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

extension SettingsChangePasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField || textField === newPasswordTextField || textField === newPasswordConfirmationTextField {
            textField.resignFirstResponder()

            return false
        }

        return true
    }
}
