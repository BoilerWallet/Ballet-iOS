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

    @IBOutlet weak var blockiesView: BlockiesSelectionView!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        showSelection()
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

        // Motion
        isMotionEnabled = true
    }

    private func showSelection() {
        DispatchQueue.global().async { [weak self] in
            var accounts = [EthereumPrivateKey]()
            for _ in 0..<6 {
                try? accounts.append(EthereumPrivateKey())
            }
            guard accounts.count == 6 else {
                // TODO: Error handling
                return
            }
            DispatchQueue.main.sync {
                self?.blockiesView.setAccounts(accounts: accounts.map({ return $0.address }))
            }
        }
    }

    // MARK: - Actions

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
