//
//  Account.swift
//  Ballet
//
//  Created by Koray Koska on 23.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import RealmSwift
import Web3
import PromiseKit

class Account: Object {

    @objc dynamic var accountID = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var keystore: String = ""

    override static func primaryKey() -> String? {
        return "accountID"
    }
}
