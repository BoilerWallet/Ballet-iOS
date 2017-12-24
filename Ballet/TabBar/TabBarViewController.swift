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
        
        // Change to Material Tab Bar
        
        if let walletCont = UIStoryboard(name: "Wallet", bundle: nil).instantiateInitialViewController() {
            let walletImg = UIImage(named: "ic_wallet")?.withRenderingMode(.alwaysTemplate)
            walletCont.tabBarItem = UITabBarItem(title: "Wallet", image: walletImg, tag: 0)
            tabBarList.append(walletCont)
        }
        
        if let sendCont = UIStoryboard(name: "Send", bundle: nil).instantiateInitialViewController() {
            let sendImg = UIImage(named: "ic_call_made")?.withRenderingMode(.alwaysTemplate)
            sendCont.tabBarItem = UITabBarItem(title: "Send", image: sendImg, tag: 1)
            tabBarList.append(sendCont)
        }
        
        if let reciveCont = UIStoryboard(name: "Recive", bundle: nil).instantiateInitialViewController() {
            let reciveImg = UIImage(named: "ic_call_received")?.withRenderingMode(.alwaysTemplate)
            reciveCont.tabBarItem = UITabBarItem(title: "Recive", image: reciveImg, tag: 2)
            tabBarList.append(reciveCont)
        }
        
        if let settingsCont = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() {
            let settingsImg = UIImage(named: "ic_settings")?.withRenderingMode(.alwaysTemplate)
            settingsCont.tabBarItem = UITabBarItem(title: "Settings", image: settingsImg, tag: 3)
            tabBarList.append(settingsCont)
        }
        
        self.viewControllers = tabBarList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
