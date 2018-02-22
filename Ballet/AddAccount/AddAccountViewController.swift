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

class AddAccountViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var selectBlockiesLabel: UILabel!

    @IBOutlet weak var blockiesView: BlockiesSelectionView!

    @IBOutlet weak var reloadBlockiesButton: RaisedButton!

    @IBOutlet weak var accountNameTextField: TextField!

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

        // Reload button
        reloadBlockiesButton.backgroundColor = Colors.accentColor
        reloadBlockiesButton.titleColor = Colors.lightPrimaryTextColor
        reloadBlockiesButton.title = "Reload"
        reloadBlockiesButton.addTarget(self, action: #selector(reloadBlockiesButtonClicked), for: .touchUpInside)

        // Account name
        accountNameTextField.placeholder = "Your account's new name"
        accountNameTextField.setupProjectDefault()
        accountNameTextField.autocorrectionType = .no

        // Motion
        isMotionEnabled = true
    }

    private func generateAccounts() {
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
            DispatchQueue.main.sync {
                self?.blockiesView.setAccounts(accounts: accounts.map({ return $0.address })) { [weak self] in
                    self?.blockiesView.loadingView.stopLoading()
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func reloadBlockiesButtonClicked() {
        generateAccounts()
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
