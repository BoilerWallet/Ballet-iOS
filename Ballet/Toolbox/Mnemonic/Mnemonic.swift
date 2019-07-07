//
//  Mnemonic.swift
//  Ballet
//
//  Created by Koray Koska on 07.07.19.
//  Copyright © 2019 Boilertalk. All rights reserved.
//

import UIKit
import CryptoSwift

public class Mnemonic: NSObject {

    enum Error: Swift.Error {
        case invalidStrength
        case unableToGetRandomData
        case unableToCreateSeedData
    }

    public static func mnemonicString(from hexString: String, language: MnemonicLanguageType) throws -> String {
        let seedData = try hexString.dataWithHexString()
        let hashData = seedData.sha256()

        var seedBits = seedData.toBitArray()
        let checkSum = hashData.toBitArray()

        for i in 0..<(seedBits.count / 32) {
            seedBits.append(checkSum[i])
        }

        let words = language.words()

        let mnemonicCount = seedBits.count / 11
        var mnemonic = [String]()
        for i in 0..<mnemonicCount {
            let length = 11
            let startIndex = i * length
            let subArray = seedBits[startIndex..<startIndex + length]
            let subString = subArray.joined(separator: "")

            let index = Int(strtoul(subString, nil, 2))
            mnemonic.append(words[index])
        }
        return mnemonic.joined(separator: " ")
    }

    public static func deterministicSeedString(from mnemonic: String, passphrase: String = "", language: MnemonicLanguageType) throws -> String {
        func normalized(string: String) -> Data? {
            guard let data = string.data(using: .utf8, allowLossyConversion: true) else {
                return nil
            }

            guard let dataString = String(data: data, encoding: .utf8) else {
                return nil
            }

            guard let normalizedData = dataString.data(using: .utf8, allowLossyConversion: false) else {
                return nil
            }
            return normalizedData
        }

        guard let normalizedData = normalized(string: mnemonic) else {
            return ""
        }

        guard let saltData = normalized(string: "mnemonic" + passphrase) else {
            return ""
        }

        let password = normalizedData.bytes
        let salt = saltData.bytes

        do {
            let bytes = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 2048, variant: .sha512).calculate()

            return bytes.toHexString()
        } catch {
            throw error
        }
    }

    public static func generateMnemonic(strength: Int, language: MnemonicLanguageType) throws -> String {
        guard strength % 32 == 0 else {
            throw Error.invalidStrength
        }

        let count = strength / 8
        guard let bytes = [UInt8].secureRandom(count: count) else {
            throw Error.unableToGetRandomData
        }

        let data = Data(bytes: bytes)
        let hexString = data.toHexString()

        return try mnemonicString(from: hexString, language: language)
    }
}
