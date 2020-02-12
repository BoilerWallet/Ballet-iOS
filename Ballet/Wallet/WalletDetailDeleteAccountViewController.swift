//
//  WalletDetailDeleteAccountViewController.swift
//  Ballet
//
//  Created by Koray Koska on 26.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MDCButton
import PromiseKit
import RealmSwift

class WalletDetailDeleteAccountViewController: UIViewController {

    // MARK: - Properties

    var account: EncryptedAccount!
    var completion: ((_ deleted: Bool) -> Void)?

    @IBOutlet weak var loadingView: LoadingView!

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var passwordTextField: ErrorTextField!

    @IBOutlet weak var deleteButton: MDCRaisedButton!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        guard account != nil else {
            backClicked()
            return
        }

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = Colors.background

        // Toolbar
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor

        navigationItem.titleLabel.text = "Delete Account"

        // Info Label
        infoLabel.setupTitleLabel()
        let infoText = """
        If you delete your account you will lose access to it and the associated coin balances forever!
        Please only continue if you are absolutely sure that's what you want.
        Enter your password to continue.
        """
        infoLabel.text = infoText

        // TextField
        passwordTextField.placeholder = "Password"
        passwordTextField.setupProjectDefault()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        passwordTextField.errorColor = Color.red.base
        passwordTextField.error = "Your password is wrong. Please try again."
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)

        // Save Button
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        deleteButton.setBackgroundColor(Colors.accentColor)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        deleteButton.isEnabled = false
        deleteButton.setBackgroundColor(Color.gray, for: .disabled)
    }

    // MARK: - Actions

    @objc private func backClicked() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func passwordTextFieldChanged() {
        if let text = passwordTextField.text, !text.isEmpty {
            deleteButton.isEnabled = true
        } else {
            deleteButton.isEnabled = false
        }
    }

    @objc private func deleteButtonClicked() {
        guard let passwordText = passwordTextField.text, let passwordData = passwordText.data(using: .utf8) else {
            return
        }
        deleteButton.isEnabled = false
        loadingView.startLoading()

        firstly {
            LoggedInUser.checkPassword(passwordData: passwordData)
        }.then { () -> Promise<()> in
            // Success, delete account, call completion
            self.passwordTextField.isErrorRevealed = false

            let realm = try Realm()
            try realm.write {
                realm.delete(self.account.account)
            }

            return Promise { seal in
                seal.fulfill(())
            }
        }.done {
            self.backClicked()
            self.completion?(true)
        }.catch { error in
            if (error as? LoggedInUser.CheckPasswordError) == .passwordWrong {
                self.passwordTextField.isErrorRevealed = true
            } else {
                Dialog().details("Something went wrong. Please try again later and file an issue on Github.").positive("OK", handler: nil).show(self)
            }
        }.finally {
            self.deleteButton.isEnabled = true
            self.loadingView.stopLoading()
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

extension WalletDetailDeleteAccountViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === passwordTextField {
            textField.resignFirstResponder()

            return false
        }

        return true
    }
}
