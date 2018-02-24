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

    private static var defaultRPCUrls: [RPCUrl] {
        let mainnet = RPCUrl()
        mainnet.name = "Infura Mainnet"
        mainnet.url = "https://mainnet.infura.io/m6d0dZdIbdR5d6bvHDQj"
        mainnet.chainId = 1
        mainnet.isActive = true

        let ropsten = RPCUrl()
        ropsten.name = "Infura Ropsten"
        ropsten.url = "https://ropsten.infura.io/m6d0dZdIbdR5d6bvHDQj"
        ropsten.chainId = 3

        let rinkeby = RPCUrl()
        rinkeby.name = "Infura Rinkeby"
        rinkeby.url = "https://rinkeby.infura.io/m6d0dZdIbdR5d6bvHDQj"
        rinkeby.chainId = 4

        let kovan = RPCUrl()
        kovan.name = "Infura Kovan"
        kovan.url = "https://kovan.infura.io/m6d0dZdIbdR5d6bvHDQj"
        kovan.chainId = 42

        return [mainnet, ropsten, rinkeby, kovan]
    }

    static var activeUrl: RPCUrl? {
        guard let realm = try? Realm() else {
            return nil
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
                return nil
            }
        }

        return urls.filter("isActive == true").first
    }

    static var activeWeb3: Web3? {
        guard let url = RPC.activeUrl else {
            return nil
        }

        return Web3(rpcURL: url.url)
    }
}
