//
//  TabBarViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/19/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class TabBarViewController: TabsController {

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Motion
        isMotionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare() {
        // Setup SubView Controllers
        var tabBarList = [UIViewController]()

        if let walletCont = UIStoryboard(name: "Wallet", bundle: nil).instantiateInitialViewController() {
            tabBarList.append(walletCont)
        }

        if let sendCont = UIStoryboard(name: "Send", bundle: nil).instantiateInitialViewController() {
            tabBarList.append(sendCont)
        }

        if let receiveCont = UIStoryboard(name: "Receive", bundle: nil).instantiateInitialViewController() {
            tabBarList.append(receiveCont)
        }

        if let settingsCont = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() {
            tabBarList.append(settingsCont)
        }

        self.viewControllers = tabBarList

        super.prepare()

        // Colors
        tabBar.setLineColor(Colors.secondaryColor, for: .selected)
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Colors.secondaryColor, for: .selected)
        tabBar.setTabItemsColor(Colors.secondaryColor, for: .highlighted)

        // Animation
        motionTransitionType = .none
    }
}
