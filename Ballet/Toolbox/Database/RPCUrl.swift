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

    var isRopsten: Bool {
        return chainId == 3
    }

    var isTestnet: Bool {
        return chainId == 2 || chainId == 3 || chainId == 4 || chainId == 42
    }

    var etherscanBaseUrl: String? {
        switch chainId {
        case 1:
            return "https://etherscan.io"
        case 3:
            return "https://ropsten.etherscan.io"
        case 4:
            return "https://rinkeby.etherscan.io"
        case 42:
            return "https://kovan.etherscan.io"
        default:
            return nil
        }
    }
}
