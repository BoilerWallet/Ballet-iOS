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
import SafariServices
import Cartography

class WalletViewController: UIViewController {

    @IBOutlet weak var addAccountButton: FABButton!

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

        setupAddAccountButton()

        // Motion
        isMotionEnabled = true
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Ballet"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor

        let rate = IconButton(image: Icon.favoriteBorder, tintColor: Colors.lightPrimaryTextColor)
        rate.addTarget(self, action: #selector(rateClicked), for: .touchUpInside)

        navigationItem.rightViews = [rate]
    }

    private func setupAddAccountButton() {
        addAccountButton.backgroundColor = Colors.secondaryColor

        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysTemplate)
        addAccountButton.setImage(image, for: .normal)
        addAccountButton.setImage(image, for: .selected)

        addAccountButton.tintColor = Colors.white

        addAccountButton.pulseColor = .white

        addAccountButton.addTarget(self, action: #selector(addAccountButtonClicked), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func addAccountButtonClicked() {
        guard let controller = UIStoryboard(name: "AddAccount", bundle: nil).instantiateInitialViewController() else {
            return
        }

        PopUpController.instantiate(from: self, with: controller)
    }

    @objc private func rateClicked() {
        if UserDefaults.standard.bool(forKey: "reviewed") {
            donate()
        } else {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: "reviewed")
            } else {
                donate()
            }
        }
    }

    private func donate() {
        let path = "https://ballet.boilertalk.com/donate"
        guard let url = NSURL(string: path) else { return }

        if #available(iOS 9.0, *) {
            let controller: SFSafariViewController = SFSafariViewController(url: url as URL)
            self.present(controller, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
