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

class SendViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromDropDownView: UIView!
    @IBOutlet weak var fromSelectedImage: UIImageView!
    @IBOutlet weak var fromSelectedName: UILabel!
    @IBOutlet weak var fromSelectedAddress: UILabel!

    private let dropDown = DropDown()

    private var accounts: Results<Account>?

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

        // Get accounts
        accounts = try? Realm().objects(Account.self)
        if accounts == nil {
            // TODO: Error handling
        }
        var ids: [String] = []
        if let accounts = accounts {
            for i in 0..<accounts.count {
                ids.append(String(i))
            }
        }

        // DropDown
        dropDown.anchorView = fromDropDownView
        dropDown.dataSource = ids

        dropDown.cellNib = UINib(nibName: "SendFromDropDownCell", bundle: nil)

        dropDown.customCellConfiguration = { index, item, cell in
            guard let cell = cell as? SendFromDropDownCell else {
                return
            }
            guard let account = self.accounts?[index] else {
                return
            }

            cell.setAccount(account: account)
        }
        dropDown.direction = .bottom
        dropDown.cellHeight = 64

        dropDown.selectionAction = { index, string in
            guard let account = self.accounts?[index] else {
                return
            }

            self.selectAccount(account: account)
        }
        // End DropDown

        fromDropDownView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromDropDownViewClicked)))

        fromLabel.setupTitleLabel()
        fromLabel.text = "From"

        fromSelectedImage.layer.cornerRadius = fromSelectedImage.bounds.width / 2
        fromSelectedImage.layer.masksToBounds = true

        fromSelectedName.setupTitleLabel()
        fromSelectedName.text = "-"

        fromSelectedAddress.setupSubTitleLabel()
        fromSelectedAddress.text = "Click here to select"
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Send"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
    }

    // MARK: - Actions

    @objc private func fromDropDownViewClicked() {
        dropDown.show()
    }

    private func selectAccount(account: Account) {
        fromSelectedName.text = account.name
        let address = try? EthereumPrivateKey(hexPrivateKey: account.privateKey).address.hex(eip55: true)
        fromSelectedAddress.text = address

        let scale = Int(ceil((fromSelectedImage.bounds.width * fromSelectedImage.bounds.height) / 24))
        DispatchQueue.global().async { [weak self] in
            let blockie = Blockies(seed: address ?? "", size: 8, scale: 3).createImageCached()

            DispatchQueue.main.sync {
                self?.fromSelectedImage.image = scale > 1 ? scale > 2 ? blockie?.high : blockie?.medium : blockie?.low
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
