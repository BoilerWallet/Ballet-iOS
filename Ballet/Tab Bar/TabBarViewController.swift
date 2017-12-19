//
//  TabBarViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/19/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let walletCont = WalletViewController()
        let walletImg = UIImage(named: "ic_wallet")
        walletCont.tabBarItem = UITabBarItem(title: "Wallet", image: walletImg, tag: 0)
        
        let tabBarList = [walletCont]
        self.viewControllers = tabBarList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
