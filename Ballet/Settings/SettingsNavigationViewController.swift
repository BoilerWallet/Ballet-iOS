//
//  SettingsNavigationViewController.swift
//  Ballet
//
//  Created by Ben Koska on 12/27/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

import UIKit
import Material

class SettingsNavigationViewController: NavigationController {

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
        navigationBar.backgroundColor = Colors.primaryColor

        // Set tintcolor for navigationbar (for example back button)
        navigationBar.tintColor = Colors.lightPrimaryTextColor
    }



}

// MARK: - TabBar

extension SettingsNavigationViewController {

    fileprivate func prepareTabItem() {
        tabItem.title = nil
        tabItem.image = UIImage(named: "ic_settings")?.withRenderingMode(.alwaysTemplate)
    }
}
