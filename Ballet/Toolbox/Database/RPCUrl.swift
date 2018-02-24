//
//  RPCUrl.swift
//  Ballet
//
//  Created by Koray Koska on 24.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import RealmSwift

class RPCUrl: Object {

    @objc dynamic var name: String = "<No Name>"
    @objc dynamic var url: String = ""
    @objc dynamic var chainId: Int = 1
    @objc dynamic var isActive: Bool = false

    var isMainnet: Bool {
        return chainId == 1
    }

    var isTestnet: Bool {
        return chainId == 2 || chainId == 3 || chainId == 4 || chainId == 42
    }
}
