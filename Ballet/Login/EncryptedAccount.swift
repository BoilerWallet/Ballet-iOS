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

    func decryptedAccount() -> Promise<DecryptedAccount> {
        return Promise { seal in
            DispatchQueue.global().async {
                do {
                    let dec = try LoggedInUser.shared.decryptedAccount(for: self)
                    seal.fulfill(dec)
                } catch {
                    seal.reject(error)
                }
            }
        }
    }

    func privateKey() -> Promise<EthereumPrivateKey> {
        return decryptedAccount().then { decryptedAccount in
            decryptedAccount.privateKey.promise
        }
    }

    /// Too slow. Use signTransactionAsync
    /// private func signTransaction(_ tx: EthereumTransaction, chainId: EthereumQuantity) throws -> EthereumSignedTransaction {
    ///     return try tx.sign(with: privateKey(), chainId: chainId)
    /// }

    func signTransactionAsync(_ tx: EthereumTransaction, chainId: EthereumQuantity) -> Promise<EthereumSignedTransaction> {
        return firstly {
            privateKey()
        }.then { privateKey in
            return Promise { seal in
                DispatchQueue.global().async {
                    do {
                        let signed = try tx.sign(with: privateKey, chainId: chainId)
                        seal.fulfill(signed)
                    } catch {
                        seal.reject(error)
                    }
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
