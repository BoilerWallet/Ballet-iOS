//
//  ERC20TrackedToken.swift
//  Ballet
//
//  Created by Koray Koska on 24.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import RealmSwift

class ERC20TrackedToken: Object {

    @objc dynamic var erc20TrackedTokenID = UUID().uuidString
    @objc dynamic var addressString: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var symbol: String = ""
    @objc dynamic var decimals: Int = 0
    @objc dynamic var rpcUrlID: String = ""

    override static func primaryKey() -> String? {
        return "erc20TrackedTokenID"
    }
}
