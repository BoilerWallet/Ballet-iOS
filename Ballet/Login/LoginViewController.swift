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

class LoginViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var balletLabel: UILabel!

    @IBOutlet weak var loginCard: MDCCard!
    @IBOutlet weak var passwordTextfield: ErrorTextField!
    @IBOutlet weak var passwordConfirmationTextfield: ErrorTextField!
    @IBOutlet weak var loginButton: MDCRaisedButton!

    @IBOutlet weak var loginCardBottomConstraint: NSLayoutConstraint!

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
        passwordTextfield.detailColor = Color.red.base
        passwordTextfield.detail = "Password is too weak. At least 8 characters."
        passwordTextfield.addTarget(self, action: #selector(passwordTextfieldChanged), for: .editingChanged)

        passwordConfirmationTextfield.placeholder = "Confirm Password"
        passwordConfirmationTextfield.setupProjectDefault()
        passwordConfirmationTextfield.isSecureTextEntry = true
        passwordConfirmationTextfield.autocorrectionType = .no
        passwordConfirmationTextfield.returnKeyType = .done
        passwordConfirmationTextfield.delegate = self
        passwordConfirmationTextfield.detailColor = Color.red.base
        passwordConfirmationTextfield.detail = "Password is too weak. At least 8 characters."
        passwordConfirmationTextfield.addTarget(self, action: #selector(passwordTextfieldChanged), for: .editingChanged)

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
        if let t1 = passwordTextfield.text?.isEmpty, !t1, let t2 = passwordConfirmationTextfield.text?.isEmpty, !t2 {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }

    @objc private func loginButtonClicked() {
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
