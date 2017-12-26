//
//  SendNavigationViewController.swift
//  Ballet
//
//  Created by Koray Koska on 26.12.17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class SendNavigationViewController: UINavigationController {

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

extension SendNavigationViewController {

    fileprivate func prepareTabItem() {
        tabItem.title = nil
        tabItem.image = UIImage(named: "ic_call_made")?.withRenderingMode(.alwaysTemplate)
    }
}
