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
    
    var accountBtn = dropDownBtn()

    @IBOutlet weak var amountField: TextField!
    @IBOutlet weak var fromAccount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        amountField.keyboardType = UIKeyboardType.numberPad
        
        accountBtn = dropDownBtn.init(frame: fromAccount.frame)
        
        accountBtn.setTitle(Values.defaultAccount.asTxtMsg(), for: .normal)
        
        //Add Button to the View Controller
        self.view.addSubview(accountBtn)
        //Set the drop down menu's options
        accountBtn.dropView.dropDownOptions = [String]()
        for account in Values.accounts {
            accountBtn.dropView.dropDownOptions.append(account.asTxtMsg())
        }
        
        // loadAccount(Values.defaultAccount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAccount(_ account: walletAccount) {
//        let blockie = Blockies(seed: account.public_key, size: 8, scale: 3)
//        let img = blockie.createImage(customScale: 2)
//        blockieImageView.image = img
//        let accountStr = account.name + " - " + 100000.description + " ETH"
//        accountLabel.text = accountStr
    }
}
