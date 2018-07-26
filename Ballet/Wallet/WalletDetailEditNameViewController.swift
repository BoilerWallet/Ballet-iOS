//
//  WalletDetailEditNameViewController.swift
//  Ballet
//
//  Created by Koray Koska on 26.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MDCButton
import RealmSwift

class WalletDetailEditNameViewController: UIViewController {

    // MARK: - Properties

    var account: EncryptedAccount!
    var completion: ((_ newName: String) -> Void)?

    @IBOutlet weak var nameTextField: ErrorTextField!
    @IBOutlet weak var saveButton: MDCRaisedButton!

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
        // Toolbar
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor

        navigationItem.titleLabel.text = "Edit Name"

        // TextField
        nameTextField.placeholder = "Account Name"
        nameTextField.setupProjectDefault()
        nameTextField.autocorrectionType = .no
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        nameTextField.detailColor = Color.red.base
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        nameTextField.text = account.account.name

        // Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        saveButton.setBackgroundColor(Colors.accentColor)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.setBackgroundColor(Color.gray, for: .disabled)
    }

    // MARK: - Actions

    @objc private func backClicked() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func nameTextFieldChanged() {
        if let text = nameTextField.text, !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    @objc private func saveButtonClicked() {
        guard let text = nameTextField.text else {
            return
        }
        saveButton.isEnabled = false

        do {
            let realm = try Realm()
            try realm.write {
                account.account.name = text
            }
        } catch {
            print("Account Name could not be saved!")
        }

        backClicked()
        completion?(text)
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

extension WalletDetailEditNameViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameTextField {
            textField.resignFirstResponder()

            return false
        }

        return true
    }
}
