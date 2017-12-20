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
        
        var tabBarList = [UIViewController]()
        
        if let walletCont = UIStoryboard(name: "Wallet", bundle: nil).instantiateInitialViewController() {
            let walletImg = UIImage(named: "ic_wallet")?.withRenderingMode(.alwaysTemplate)
            walletCont.tabBarItem = UITabBarItem(title: "Wallet", image: walletImg, tag: 0)
            tabBarList.append(walletCont)
        }
        
        if let sendCont = UIStoryboard(name: "Send", bundle: nil).instantiateInitialViewController() {
            let walletImg = UIImage(named: "ic_send")?.withRenderingMode(.alwaysTemplate)
            sendCont.tabBarItem = UITabBarItem(title: "Send", image: walletImg, tag: 0)
            tabBarList.append(sendCont)
        }
        
        self.viewControllers = tabBarList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
