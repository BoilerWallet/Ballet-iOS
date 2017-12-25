//
//  Values.swift
//  Ballet
//
//  Created by Ben Koksa on 12/22/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import Foundation

class Values {
    static let defaultAccount = Account(public_key: "0xa8fa5dd30a87bb9e3288d604eb74949c515ab66e", name: "Default", wei: weiPerEther)
    // static let emptyAccount =
    static let accounts: [Account] = [defaultAccount]
    static let weiPerEther = pow(10, 18)
}
