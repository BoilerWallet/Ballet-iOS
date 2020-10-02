//
//  SolidityInvocation+CreateTransactionAsync.swift
//  Ballet
//
//  Created by Koray Koska on 20.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Web3
import Web3PromiseKit
import Web3ContractABI

enum SolidityInvocationCreateTransactionError: Error {

    case transactionCreationFailed
}

extension SolidityInvocation {

    public func createTransactionAsync(nonce: EthereumQuantity? = nil, from: EthereumAddress, value: EthereumQuantity?, gas: EthereumQuantity, gasPrice: EthereumQuantity?) -> Promise<EthereumTransaction> {
        return Promise { seal in
            DispatchQueue.global().async {
                guard let tx = self.createTransaction(nonce: nonce, from: from, value: value, gas: gas, gasPrice: gasPrice) else {
                    seal.reject(SolidityInvocationCreateTransactionError.transactionCreationFailed)
                    return
                }

                seal.fulfill(tx)
            }
        }
    }
}
