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
    
    var accountBtn = accountDropDownBtn()

    @IBOutlet weak var amountField: TextField!
    @IBOutlet weak var fromAccount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        amountField.keyboardType = UIKeyboardType.numberPad
        
        accountBtn = accountDropDownBtn.init(frame: fromAccount.frame)
        
        accountBtn.setTitle(Values.defaultAccount.asTxtMsg(), for: .normal)
        accountBtn.setImage(Values.defaultAccount.getBlockie(size: 12, scale: 2), for: UIControlState.normal)
        accountBtn.semanticContentAttribute = .forceLeftToRight
        
        //Add Button to the View Controller
        self.view.addSubview(accountBtn)
        //Set the drop down menu's options
        accountBtn.dropView.AccountDropDownOptions = [Account]()
        for account in Values.accounts {
            accountBtn.dropView.AccountDropDownOptions.append(account)
        }
        
        // loadAccount(Values.defaultAccount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAccount(_ account: Account) {
//        let blockie = Blockies(seed: account.public_key, size: 8, scale: 3)
//        let img = blockie.createImage(customScale: 2)
//        blockieImageView.image = img
//        let accountStr = account.name + " - " + 100000.description + " ETH"
//        accountLabel.text = accountStr
    }
}
