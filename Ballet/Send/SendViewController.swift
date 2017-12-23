//
//  SendViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import DropDown
import BlockiesSwift

class SendViewController: UIViewController {

    @IBOutlet weak var amountField: TextField!
    @IBOutlet weak var fromAccount: UIView!
    @IBOutlet weak var blockieImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        amountField.keyboardType = UIKeyboardType.numberPad
        
//        let dropDown = DropDown()
//
//        // The view to which the drop down will appear on
//        dropDown.anchorView = fromAccount // UIView or UIBarButtonItem
//
//        // The list of items to display. Can be changed dynamically
//        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        loadAccount(Values.defaultAccount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAccount(_ account: walletAccount) {
        let blockie = Blockies(seed: account.public_key, size: 8, scale: 3)
        let img = blockie.createImage(customScale: 2)
        blockieImageView.image = img
        let accountStr = account.name + " - " + 100000.description + " ETH"
        accountLabel.text = accountStr
    }
}
