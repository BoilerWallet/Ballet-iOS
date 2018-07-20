//
//  DecryptedAccount.swift
//  Ballet
//
//  Created by Koray Koska on 28.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Web3

class DecryptedAccount {

    let privateKey: EthereumPrivateKey
    let account: Account

    init(privateKey: EthereumPrivateKey, account: Account) {
        self.privateKey = privateKey
        self.account = account
    }

    func signTransaction(_ tx: EthereumTransaction, chainId: EthereumQuantity) throws -> EthereumSignedTransaction {
        return try tx.sign(with: privateKey, chainId: chainId)
    }
}
