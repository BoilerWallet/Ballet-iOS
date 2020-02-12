//
//  RPC.swift
//  Ballet
//
//  Created by Koray Koska on 24.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import RealmSwift
import Web3

struct RPC {

    private static var defaultMainnetRPCUrl: RPCUrl {
        let mainnet = RPCUrl()
        mainnet.name = "Infura Mainnet"
        mainnet.url = "https://mainnet.infura.io/v3/70dda7e4645e40c89a972a0c8693dd5c"
        mainnet.chainId = 1
        mainnet.isActive = true

        return mainnet
    }

    private static var defaultRPCUrls: [RPCUrl] {
        let mainnet = defaultMainnetRPCUrl

        let ropsten = RPCUrl()
        ropsten.name = "Infura Ropsten"
        ropsten.url = "https://ropsten.infura.io/v3/70dda7e4645e40c89a972a0c8693dd5c"
        ropsten.chainId = 3

        let rinkeby = RPCUrl()
        rinkeby.name = "Infura Rinkeby"
        rinkeby.url = "https://rinkeby.infura.io/v3/70dda7e4645e40c89a972a0c8693dd5c"
        rinkeby.chainId = 4

        let kovan = RPCUrl()
        kovan.name = "Infura Kovan"
        kovan.url = "https://kovan.infura.io/v3/70dda7e4645e40c89a972a0c8693dd5c"
        kovan.chainId = 42

        return [mainnet, ropsten, rinkeby, kovan]
    }

    static var activeUrl: RPCUrl {
        guard let realm = try? Realm() else {
            // Default is currently the mainnet.
            return defaultMainnetRPCUrl
        }
        let urls = realm.objects(RPCUrl.self)
        if urls.count == 0 {
            let newUrls = RPC.defaultRPCUrls
            try? realm.write {
                for u in newUrls {
                    realm.add(u)
                }
            }
            if urls.count < newUrls.count {
                // Default is currently the mainnet.
                return defaultMainnetRPCUrl
            }
        }

        guard let activeUrl = urls.filter("isActive == true").first else {
            // Default is currently the mainnet.
            return defaultMainnetRPCUrl
        }

        return activeUrl
    }

    static var activeWeb3: Web3 {
        return Web3(rpcURL: activeUrl.url)
    }
}
