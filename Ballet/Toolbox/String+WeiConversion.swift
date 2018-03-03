//
//  String+WeiConversion.swift
//  Ballet
//
//  Created by Koray Koska on 02.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

extension String {

    func ethToWei() -> BigUInt? {
        var weiAmount = ""

        let splitted = self.split(separator: ".")
        guard splitted.count == 2 || splitted.count == 1 else {
            return nil
        }

        weiAmount += String(splitted[0])
        if splitted.count > 1 {
            var decimal = String(splitted[1])
            if decimal.count > 18 {
                return nil
            }
            if decimal.count < 18 {
                for _ in 0..<(18 - decimal.count) {
                    decimal += "0"
                }
            }

            weiAmount += decimal
        } else {
            var decimal = ""
            for _ in 0..<18 {
                decimal += "0"
            }

            weiAmount += decimal
        }

        return BigUInt(weiAmount, radix: 10)
    }

    func weiToEthStr() -> String {
        var eth = ""

        var copy = self

        if copy.count <= 18 {
            for _ in 0..<(19 - copy.count) {
                copy.insert("0", at: copy.startIndex)
            }
        }

        let chars: [Character] = copy.reversed()
        for i in 0..<chars.count {
            eth.insert(chars[i], at: eth.startIndex)
            if i == 17 {
                eth.insert(".", at: eth.startIndex)
            }
        }

        // Remove trailing zeros
        var trailingZeros = 0
        for i in (0..<eth.count).reversed() {
            if eth[eth.index(eth.startIndex, offsetBy: i)] != "0" {
                break
            }
            trailingZeros += 1
        }
        let endIndex = eth.index(eth.startIndex, offsetBy: eth.count - trailingZeros)
        eth = String(eth[eth.startIndex..<endIndex])

        return eth
    }

    func weiToEth() -> Double? {
        return Double(weiToEthStr())
    }

    func weiToGweiStr() -> String {
        var gwei = ""

        var copy = self

        if copy.count <= 9 {
            for _ in 0..<(10 - copy.count) {
                copy.insert("0", at: copy.startIndex)
            }
        }

        let chars: [Character] = copy.reversed()
        for i in 0..<chars.count {
            gwei.insert(chars[i], at: gwei.startIndex)
            if i == 8 {
                gwei.insert(".", at: gwei.startIndex)
            }
        }

        // Remove trailing zeros
        var trailingZeros = 0
        for i in (0..<gwei.count).reversed() {
            if gwei[gwei.index(gwei.startIndex, offsetBy: i)] != "0" {
                break
            }
            trailingZeros += 1
        }
        let endIndex = gwei.index(gwei.startIndex, offsetBy: gwei.count - trailingZeros)
        gwei = String(gwei[gwei.startIndex..<endIndex])

        return gwei
    }
}
