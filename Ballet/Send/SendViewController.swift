//
//  SendViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import DropDown
import BlockiesSwift

class SendViewController: UIViewController {

    // MARK: - Properties

    // var accountBtn = accountDropDownBtn()

    @IBOutlet weak var amountField: TextField!
    @IBOutlet weak var fromAccount: UIView!

    @IBOutlet weak var RecipientTextField: TextField!
    let dropDown = DropDown()

    var selectedAccount: Account = Values.defaultAccount

    @IBOutlet weak var fromLabel: UILabel!
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Setup

    private func setupUI() {

        RecipientTextField.tag = 123
        RecipientTextField.delegate = self

        fromLabel.text = Values.defaultAccount.asTxtMsg()

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dropDownPressed))
        fromAccount.addGestureRecognizer(recognizer)
        setupToolbar()

        setupDropDowns()

        amountField.keyboardType = UIKeyboardType.numberPad

        // The view to which the drop down will appear on
        dropDown.anchorView = fromAccount

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = [String]()

        for account in Values.accounts {
            dropDown.dataSource.append(account.asTxtMsg())
        }

    }

    private func setupDropDowns() {
        dropDown.anchorView = fromAccount
        dropDown.dataSource = []

        for account in Values.accounts {
            dropDown.dataSource.append(account.asTxtMsg())
        }

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedAccount = Values.accounts[index]
            self.fromLabel.text = item
            self.dropDown.hide()
        }

        dropDown.width = fromAccount.frame.size.width

    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Send"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor

        let qrImage = UIImage(named: "ic_qrcode")?.withRenderingMode(.alwaysTemplate)
        let qr = IconButton(image: qrImage, tintColor: Colors.lightPrimaryTextColor)

        qr.addTarget(self, action: #selector(scanQR), for: .touchUpInside)

        navigationItem.rightViews = [qr]
    }

    @objc private func scanQR() {
        let module = QRModule { (data) in
            print("Address: \(data.address)")
            print("Amount: \(data.amount)")
            print("Gas: \(data.gas)")
        }
        module.present(on: self)
    }

    @objc private func dropDownPressed() {
        dropDown.show()
    }
}

//MARK: - Text Field Delegate

extension SendViewController: TextFieldDelegate {
    func textField(textField: TextField, didChange text: String?) {
        if (textField.tag == 123) {
            if let txt = text {
                if txt.count == 42 {
                    let blockie = Blockies(seed: txt, size: (Int(textField.frame.height/3)), scale: 3)
                    if let img = blockie.createImage() {
                        let imageView = UIImageView(image: img)
                        imageView.layer.cornerRadius = 20
                        imageView.layer.masksToBounds = true

                        imageView.frame = CGRect(x: 0, y: 0, width: textField.frame.height, height: textField.frame.height)
                        textField.leftView = imageView
                    }
                } else {
                    let img = UIImage(named: "ic_error_outline")?.withRenderingMode(.alwaysTemplate)
                    if let img = img {
                        if let img = img.tint(with: UIColor.red) {
                            let imageView = UIImageView(image: img)
                            imageView.frame = CGRect(x: 0, y: 0, width: textField.frame.height, height: textField.frame.height)
                            textField.leftView = imageView
                        }
                    }
                }
            }
        }
    }
}
