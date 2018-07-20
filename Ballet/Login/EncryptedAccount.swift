//
//  EncryptedAccount.swift
//  Ballet
//
//  Created by Koray Koska on 18.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Web3
import Keystore

struct EncryptedAccount {

    let address: EthereumAddress
    let keystore: Keystore
    let account: Account

    func privateKey() throws -> EthereumPrivateKey {
        return try LoggedInUser.shared.decryptedAccount(for: self).privateKey
    }

    func signTransaction(_ tx: EthereumTransaction, chainId: EthereumQuantity) throws -> EthereumSignedTransaction {
        return try tx.sign(with: privateKey(), chainId: chainId)
    }

    func signTransactionAsync(_ tx: EthereumTransaction, chainId: EthereumQuantity) -> Promise<EthereumSignedTransaction> {
        return Promise { seal in
            DispatchQueue.global().async {
                do {
                    let signed = try self.signTransaction(tx, chainId: chainId)
                    seal.fulfill(signed)
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
}

extension Array where Element == EncryptedAccount {

    subscript(_ address: EthereumAddress) -> EncryptedAccount? {
        for a in self {
            if a.address == address {
                return a
            }
        }

        return nil
    }
}
