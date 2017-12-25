//
//  WalletViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/17/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import StoreKit

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

    private func setupUI() {
        self.view.backgroundColor = Colors.background

        setupToolbar()

        setupFAB()
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Ballet"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor

        let rate = IconButton(image: Icon.favoriteBorder, tintColor: Colors.lightPrimaryTextColor)
        rate.addTarget(self, action: #selector(rateClicked), for: .touchUpInside)

        navigationItem.rightViews = [rate]
    }

    private func setupFAB() {
        FABButton.backgroundColor = Colors.secondaryColor
        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.white)
        FABButton.setImage(image, for: .normal)
    }

    // MARK: - Actions

    @IBAction func fabClicked(_ sender: Any) {
    }

    @objc func rateClicked() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // TODO: Add Rating for iOS 10.2 and earlier
        }
    }
}
