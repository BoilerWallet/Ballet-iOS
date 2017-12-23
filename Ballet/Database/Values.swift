//
//  Values.swift
//  Ballet
//
//  Created by Ben Koksa on 12/22/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import Foundation

struct walletAccount {
    var public_key: String
    var name: String
}

class Values {
    static let defaultAccount = walletAccount(public_key: "0xa8fa5dd30a87bb9e3288d604eb74949c515ab66e", name: "Default")
    static let accounts: [walletAccount] = [defaultAccount]
    static let weiPerEther = pow(10, 18)
    
}
