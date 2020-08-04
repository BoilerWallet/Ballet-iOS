//
//  TabBarViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/19/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import MaterialComponents.MaterialBottomNavigation
import Cartography

class TabBarViewController: UIViewController {

    // MARK - Properties

    @IBOutlet weak var bottomBar: MDCBottomNavigationBar!
    @IBOutlet weak var containerView: UIView!

    private var tabs: [(item: UITabBarItem, vc: UIViewController)] = []
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Motion
        isMotionEnabled = true

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        bottomBar.titleVisibility = .selected
        bottomBar.alignment = .centered

        let walletItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "ic_wallet"),
            tag: 0)
        let sendItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "ic_call_made"),
            tag: 0)
        let receiveItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "ic_call_received"),
            tag: 0)
        let settingsItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "ic_settings"),
            tag: 0)

        let walletCont = UIStoryboard(name: "Wallet", bundle: nil).instantiateInitialViewController()!
        let sendCont = UIStoryboard(name: "Send", bundle: nil).instantiateInitialViewController()!
        let receiveCont = UIStoryboard(name: "Receive", bundle: nil).instantiateInitialViewController()!
        let settingsCont = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()!

        self.tabs.append((item: walletItem, vc: walletCont))
        self.tabs.append((item: sendItem, vc: sendCont))
        self.tabs.append((item: receiveItem, vc: receiveCont))
        self.tabs.append((item: settingsItem, vc: settingsCont))

        // Set BottomBar tabs
        bottomBar.items = [walletItem, sendItem, receiveItem, settingsItem]

        bottomBar.barTintColor = Color.white
        bottomBar.unselectedItemTintColor = Color.grey.base
        bottomBar.selectedItemTintColor = Colors.accentColor

        bottomBar.delegate = self

        // Default select first tab (wallet)
        bottomBar.selectItem(walletItem)
    }

//    override func prepare() {
//        // Setup SubView Controllers
//        var tabBarList = [UIViewController]()
//
//        if let walletCont = UIStoryboard(name: "Wallet", bundle: nil).instantiateInitialViewController() {
//            tabBarList.append(walletCont)
//        }
//
//        if let sendCont = UIStoryboard(name: "Send", bundle: nil).instantiateInitialViewController() {
//            tabBarList.append(sendCont)
//        }
//
//        if let receiveCont = UIStoryboard(name: "Receive", bundle: nil).instantiateInitialViewController() {
//            tabBarList.append(receiveCont)
//        }
//
//        if let settingsCont = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() {
//            tabBarList.append(settingsCont)
//        }
//
//        self.viewControllers = tabBarList
//
//        super.prepare()
//
//        // Colors
//        tabBar.setLineColor(Colors.accentColor, for: .selected)
//        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
//        tabBar.setTabItemsColor(Colors.accentColor, for: .selected)
//        tabBar.setTabItemsColor(Colors.accentColor, for: .highlighted)
//
//        // NonScrollable TabBar
//        tabBar.tabBarStyle = .nonScrollable
//
//        // Animation
//        motionTransitionType = .none
//    }
}

extension MDCBottomNavigationBar {

    func selectItem(_ item: UITabBarItem) {
        selectedItem = item
        delegate?.bottomNavigationBar?(self, didSelect: item)
    }
}

extension TabBarViewController: MDCBottomNavigationBarDelegate {

    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        for (i, vc) in self.tabs {
            if item === i {
                // Remove old vc
                let oldVC = self.childViewControllers.first
                oldVC?.willMove(toParentViewController: nil)
                oldVC?.view.removeFromSuperview()
                oldVC?.removeFromParentViewController()
                oldVC?.didMove(toParentViewController: nil)

                // Add new vc
                vc.willMove(toParentViewController: self)
                // Add to containerview
                self.containerView.addSubview(vc.view)
                constrain(containerView, vc.view) { container, view in
                    view.left == container.left
                    view.right == container.right
                    view.top == container.top
                    view.bottom == container.bottom
                }
                self.addChildViewController(vc)
                vc.didMove(toParentViewController: self)
            }
        }
    }
}
