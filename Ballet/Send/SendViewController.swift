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
        setupToolbar()

        amountField.keyboardType = UIKeyboardType.numberPad

//        accountBtn = accountDropDownBtn.init(frame: fromAccount.frame)
//
//        accountBtn.setTitle(Values.defaultAccount.asTxtMsg(), for: .normal)
//        accountBtn.setImage(Values.defaultAccount.getBlockie(size: 12, scale: 2), for: UIControlState.normal)
//        accountBtn.semanticContentAttribute = .forceLeftToRight
//
//        //Add Button to the View Controller
//        self.view.addSubview(accountBtn)
//        //Set the drop down menu's options
//        accountBtn.dropView.AccountDropDownOptions = [Account]()
//        for account in Values.accounts {
//            accountBtn.dropView.AccountDropDownOptions.append(account)
//        }

        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = fromAccount

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = [String]()

        for account in Values.accounts {
            dropDown.dataSource.append(account.asTxtMsg())
        }

        dropDown.show()

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
            print(data)
        }
        module.present(on: self)
    }
}
