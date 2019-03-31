//
//  LoginViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/17/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialCards
import CryptoSwift
import RealmSwift
import PromiseKit

class LoginViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var balletLabel: UILabel!

    @IBOutlet weak var loadingOverlay: LoadingView!

    @IBOutlet weak var loginCard: MDCCard!
    @IBOutlet weak var passwordTextfield: ErrorTextField!
    @IBOutlet weak var passwordConfirmationTextfield: ErrorTextField!
    @IBOutlet weak var loginButton: MDCRaisedButton!

    @IBOutlet weak var loginCardBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldConnectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmationButtonConstraint: NSLayoutConstraint!
    
    private var isRegister = true
    private var passwordHash: [UInt8]?
    private var salt: [UInt8]?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        if let hash = (try? ConstantHolder.passwordHash?.dataWithHexString()) ?? nil, let s = (try? ConstantHolder.passwordSalt?.dataWithHexString()) ?? nil {
            isRegister = false
            passwordHash = [UInt8](hash)
            salt = [UInt8](s)
            // Remove confirmation
            passwordConfirmationTextfield.isHidden = true
            passwordTextFieldConnectionConstraint.constant = 0
            confirmationButtonConstraint.constant = 0


        } else {
            isRegister = true
            passwordHash = nil
            salt = nil
        }

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = Colors.primaryColor

        balletLabel.setupTitleLabelWithSize(size: 64)
        balletLabel.textColor = Colors.lightPrimaryTextColor
        balletLabel.textAlignment = .center

        loginCard.inkView.inkColor = UIColor.clear

        passwordTextfield.placeholder = "Password"
        passwordTextfield.setupProjectDefault()
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.autocorrectionType = .no
        passwordTextfield.returnKeyType = .done
        passwordTextfield.delegate = self
        passwordTextfield.errorColor = Color.red.base
        passwordTextfield.error = "Password is too weak. At least 8 characters."
        passwordTextfield.addTarget(self, action: #selector(passwordTextfieldChanged), for: .editingChanged)
        // UI test specific
        passwordTextfield.accessibilityIdentifier = "password_text"

        passwordConfirmationTextfield.placeholder = "Confirm Password"
        passwordConfirmationTextfield.setupProjectDefault()
        passwordConfirmationTextfield.isSecureTextEntry = true
        passwordConfirmationTextfield.autocorrectionType = .no
        passwordConfirmationTextfield.returnKeyType = .done
        passwordConfirmationTextfield.delegate = self
        passwordConfirmationTextfield.errorColor = Color.red.base
        passwordConfirmationTextfield.error = "Your passwords didn't match"
        passwordConfirmationTextfield.addTarget(self, action: #selector(passwordTextfieldChanged), for: .editingChanged)
        // UI test specific
        passwordConfirmationTextfield.accessibilityIdentifier = "confirm_password_text"

        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        loginButton.setBackgroundColor(Colors.accentColor)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        loginButton.isEnabled = false
        loginButton.setBackgroundColor(Color.gray, for: .disabled)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - Actions

    @objc private func passwordTextfieldChanged() {
        if let t1 = passwordTextfield.text?.isEmpty, !t1, let t2 = passwordConfirmationTextfield.text?.isEmpty, (!t2 || !isRegister) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }

    @objc private func loginButtonClicked() {
        loginButton.isEnabled = false
        loadingOverlay.startLoading()

        let finishLoading: () -> Void = {
            self.loginButton.isEnabled = true
            self.loadingOverlay.stopLoading()
        }

        guard let tabController = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() else {
            finishLoading()
            return
        }

        let promise: Promise<()>
        if isRegister {
            guard let password = passwordTextfield.text, let confirmation = passwordConfirmationTextfield.text else {
                finishLoading()
                return
            }
            if password.count < 8 {
                passwordTextfield.isErrorRevealed = true
                finishLoading()
                return
            }
            passwordTextfield.isErrorRevealed = false

            if password != confirmation {
                passwordConfirmationTextfield.isErrorRevealed = true
                finishLoading()
                return
            }
            passwordConfirmationTextfield.isErrorRevealed = false

            promise = registerUser(password: password)
        } else {
            guard let hash = passwordHash, let salt = salt, let password = passwordTextfield.text, let passwordData = password.data(using: .utf8) else {
                finishLoading()
                return
            }

            promise = loginUser(password: password, passwordData: passwordData, hash: hash, salt: salt)
        }

        promise.done(on: DispatchQueue.main) {
            // Login / Register finished. Redirect
            self.present(tabController, animated: false, completion: nil)
        }.catch(on: DispatchQueue.main) { error in
            if let e = error as? LoginError, e == .passwordWrong {
                self.passwordTextfield.detail = "Your password is wrong. Please try again."
                self.passwordTextfield.isErrorRevealed = true
            } else {
                print(error)
                Dialog().details("Something went wrong. Please try again later.").positive("OK", handler: nil).show(self)
            }
        }.finally {
            DispatchQueue.main.async { [weak self] in
                self?.loginButton.isEnabled = true
                self?.loadingOverlay.stopLoading()
            }
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height

            self.loginCardBottomConstraint.constant = keyboardHeight + 32
            UIView.animate(withDuration: 0.55, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.loginCardBottomConstraint.constant = 32
        UIView.animate(withDuration: 0.55, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: - Helpers

    enum LoginError: Error {

        case internalError
        case passwordWrong
    }

    private func registerUser(password: String) -> Promise<()> {
        return Promise { seal in
            DispatchQueue.global().async {
                // Login
                guard let passwordData = password.data(using: .utf8), let salt = [UInt8].secureRandom(count: 32) else {
                    // PROMISE
                    seal.reject(LoginError.internalError)
                    return
                }
                guard let hash = try? LoggedInUser.hashPassword([UInt8](passwordData), salt: salt) else {
                    // PROMISE
                    seal.reject(LoginError.internalError)
                    return
                }

                // Save password hash
                ConstantHolder.passwordHash = Data(hash).hexString
                ConstantHolder.passwordSalt = Data(salt).hexString

                // Register successful
                LoggedInUser.shared.password = password

                // PROMISE
                seal.fulfill(())
            }
        }
    }

    private func loginUser(password: String, passwordData: Data, hash: [UInt8], salt: [UInt8]) -> Promise<Void> {
        return Promise { seal in
            DispatchQueue.global().async {
                guard let pHash = try? LoggedInUser.hashPassword([UInt8](passwordData), salt: salt) else {
                    // PROMISE
                    seal.reject(LoginError.internalError)
                    return
                }

                if pHash != hash {
                    // PROMISE
                    seal.reject(LoginError.passwordWrong)
                    return
                }

                DispatchQueue.main.async {
                    // Login successful
                    LoggedInUser.shared.password = password
                    // Decrypt accounts
                    guard let accounts: [Account] = try? Realm().objects(Account.self).map({ $0 }) else {
                        // TODO: Handle error
                        seal.reject(LoginError.internalError)
                        return
                    }

                    LoggedInUser.shared.setAccounts(accounts: accounts)

                    // PROMISE
                    seal.fulfill(())
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === passwordTextfield || textField === passwordConfirmationTextfield {
            textField.resignFirstResponder()

            return false
        }

        return true
    }
}
