//
//  LoggedInUser.swift
//  Ballet
//
//  Created by Koray Koska on 28.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import CryptoSwift
import Keystore
import Web3

class LoggedInUser {

    // MARK: - Static Helpers

    static let shared: LoggedInUser = LoggedInUser()

    static func hashPassword(_ password: [UInt8], salt: [UInt8]) throws -> [UInt8] {
        let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 8192, keyLength: 32, variant: .sha256).calculate()
        return SHA3(variant: .keccak256).calculate(for: key)
    }

    static func decryptAndSetAccounts(password: String, accounts: [Account]) -> Promise<()> {
        return Promise { seal in
            DispatchQueue.main.async {
                LoggedInUser.shared.decryptedAccounts = []

                let keystores = accounts.map({ $0.keystore })

                DispatchQueue.global().async {
                    let decoder = JSONDecoder()
                    var keys = [(index: Int, key: EthereumPrivateKey)]()

                    for i in 0..<keystores.count {
                        guard let aData = keystores[i].data(using: .utf8),
                            let keystore = try? decoder.decode(Keystore.self, from: aData),
                            let privateKeyData = try? keystore.privateKey(password: password),
                            let privateKey = try? EthereumPrivateKey(bytes: privateKeyData) else {
                                // TODO: ???
                                continue
                        }
                        keys.append((index: i, key: privateKey))
                    }

                    DispatchQueue.main.async {
                        for k in keys {
                            let decrypted = DecryptedAccount(privateKey: k.key, account: accounts[k.index])
                            LoggedInUser.shared.decryptedAccounts.append(decrypted)
                        }
                        seal.fulfill(())
                    }
                }
            }
        }
    }

    // MARK: - Properties

    var password: String = ""

    var decryptedAccounts: [DecryptedAccount] = []

    // MARK: - Initialization

    private init() {
    }
}
