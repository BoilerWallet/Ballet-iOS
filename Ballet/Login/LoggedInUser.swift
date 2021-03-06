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
import Web3PromiseKit

class LoggedInUser {

    // MARK: - Static Helpers

    static let shared: LoggedInUser = LoggedInUser()

    static func hashPassword(_ password: [UInt8], salt: [UInt8]) throws -> [UInt8] {
        let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 8192, keyLength: 32, variant: .sha256).calculate()
        return SHA3(variant: .keccak256).calculate(for: key)
    }

    enum CheckPasswordError: Error {

        case internalError
        case passwordWrong
    }

    static func checkPassword(passwordData: Data) -> Promise<Void> {
        guard let oldHash = (try? ConstantHolder.passwordHash?.dataWithHexString()) ?? nil, let oldSalt = (try? ConstantHolder.passwordSalt?.dataWithHexString()) ?? nil else {
            return Promise { seal in
                seal.reject(CheckPasswordError.internalError)
            }
        }

        return Promise { seal in
            DispatchQueue.global().async {
                guard let pHash = try? LoggedInUser.hashPassword([UInt8](passwordData), salt: [UInt8](oldSalt)) else {
                    // PROMISE
                    seal.reject(CheckPasswordError.internalError)
                    return
                }

                if pHash != [UInt8](oldHash) {
                    // PROMISE
                    seal.reject(CheckPasswordError.passwordWrong)
                    return
                }

                // PROMISE
                seal.fulfill(())
            }
        }
    }

    /*
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
    }*/

    func setAccounts(accounts: [Account]) {
        let decoder = JSONDecoder()

        for a in accounts {
            guard let aData = a.keystore.data(using: .utf8),
                let keystore = try? decoder.decode(Keystore.self, from: aData),
                let address = try? EthereumAddress(hex: keystore.address, eip55: false) else {
                    // TODO: ???
                    continue
            }

            encryptedAccounts.append(EncryptedAccount(address: address, keystore: keystore, account: a))
        }
    }

    func resetAccounts() {
        encryptedAccounts = []
        decryptedAccounts = [:]
    }

    func decryptedAccount(for encrypted: EncryptedAccount) throws -> DecryptedAccount {
        let address = encrypted.address

        if let a = decryptedAccounts[address] {
            return a
        }

        let decrypted = try DecryptedAccount(privateKey: EthereumPrivateKey(encrypted.keystore.privateKey(password: password)), account: encrypted.account)

        // Cache decrypted accounts
        decryptedAccounts[address] = decrypted

        return decrypted
    }

    // MARK: - Properties

    var password: String = ""

    var encryptedAccounts: [EncryptedAccount] = []

    private var decryptedAccounts: [EthereumAddress: DecryptedAccount] = [:]

    // MARK: - Initialization

    private init() {
    }
}
