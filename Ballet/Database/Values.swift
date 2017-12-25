//
//  Values.swift
//  Ballet
//
//  Created by Ben Koksa on 12/22/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import Foundation

class walletAccount {
    var public_key: String
    var name: String
    var wei: Decimal
    
    init (public_key: String, name: String, wei: Decimal) {
        self.public_key = public_key
        self.name = name
        self.wei = wei
    }
    
    func asTxtMsg() -> String{
        return "\(self.name) - \(self.wei / Values.weiPerEther) ETH"
    }
    //TODO: Implement function to get Blockie UIImage
}

class Values {
    static let defaultAccount = walletAccount(public_key: "0xa8fa5dd30a87bb9e3288d604eb74949c515ab66e", name: "Default", wei: weiPerEther)
    static let accounts: [walletAccount] = [defaultAccount]
    static let weiPerEther = pow(10, 18)
}
