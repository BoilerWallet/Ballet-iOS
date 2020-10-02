//
//  WalletNavigationViewController.swift
//  Ballet
//
//  Created by Koray Koska on 25.12.17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class WalletNavigationViewController: NavigationController {

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // TabBar
        prepareTabItem()
    }

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
        (navigationBar as? NavigationBar)?.backButtonImage = UIImage(named: "baseline_arrow_back_ios_black_24pt")?.withRenderingMode(.alwaysTemplate)

        navigationBar.backgroundColor = Colors.primaryColor

        // Set tintcolor for navigationbar (for example back button)
        navigationBar.tintColor = Colors.lightPrimaryTextColor
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

// MARK: - TabBar

extension WalletNavigationViewController {

    fileprivate func prepareTabItem() {
        tabItem.title = nil
        tabItem.image = UIImage(named: "ic_wallet")?.withRenderingMode(.alwaysTemplate)
    }
}
