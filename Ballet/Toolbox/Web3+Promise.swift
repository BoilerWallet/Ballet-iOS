//
//  Web3+Promise.swift
//  Ballet
//
//  Created by Koray Koska on 03.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Web3
import PromiseKit

extension Web3.Eth {

    func getBalance(address: EthereumAddress, block: EthereumQuantityTag) -> Promise<EthereumQuantity> {
        return Promise { seal in
            getBalance(address: address, block: block, response: { response in
                seal.resolve(response.rpcResponse?.result, response.rpcResponse?.error)
            })
        }
    }

    func getTransactionCount(address: EthereumAddress, block: EthereumQuantityTag) -> Promise<EthereumQuantity> {
        return Promise { seal in
            getTransactionCount(address: address, block: block, response: { response in
                seal.resolve(response.rpcResponse?.result, response.rpcResponse?.error)
            })
        }
    }

    func sendRawTransaction(transaction: EthereumTransaction) -> Promise<EthereumData> {
        return Promise { seal in
            sendRawTransaction(transaction: transaction) { response in
                seal.resolve(response.rpcResponse?.result, response.rpcResponse?.error)
            }
        }
    }
}

extension RPCResponse.Error: Error {
}
