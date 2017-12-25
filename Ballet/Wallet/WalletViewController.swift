//
//  WalletViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/17/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class WalletViewController: UIViewController {

    @IBOutlet weak var FABButton: FABButton!

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
    
    func setupUI() {
        // TabBar
        prepareTabItem()

        self.view.backgroundColor = Colors.background

        setupFAB()
    }

    private func setupFAB() {
        FABButton.backgroundColor = Colors.secondaryColor
        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.white)
        FABButton.setImage(image, for: .normal)
    }

    // MARK: - Actions

    @IBAction func fabClicked(_ sender: Any) {
    }
}

// MARK: - TabBar

extension WalletViewController {

    fileprivate func prepareTabItem() {
        // tabItem.title = "Wallet"
        tabItem.image = UIImage(named: "ic_wallet")?.withRenderingMode(.alwaysTemplate)
    }
}
