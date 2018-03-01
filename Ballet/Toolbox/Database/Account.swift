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

class Account: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var privateKey: String = "0x"
    @objc dynamic var encrypted: Bool = false
    @objc dynamic var salt: String? = nil

    // Cache generated EthereumPrivateKey
    private var key: EthereumPrivateKey?

    func ethereumPrivateKey() throws -> EthereumPrivateKey {
        if let k = key {
            return k
        }

        let k = try EthereumPrivateKey(hexPrivateKey: privateKey)
        self.key = k

        return k
    }
}
