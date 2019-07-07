//
//  Data+MnemonicBitArray.swift
//  Ballet
//
//  Created by Koray Koska on 07.07.19.
//  Copyright © 2019 Boilertalk. All rights reserved.
//

import Foundation
import CryptoSwift

fileprivate extension UInt8 {
    func stringBits() -> [String] {
        let totalBitsCount = MemoryLayout<UInt8>.size * 8

        var bitsArray = [String](repeating: "0", count: totalBitsCount)

        for j in 0 ..< totalBitsCount {
            let bitVal: UInt8 = 1 << UInt8(totalBitsCount - 1 - j)
            let check = self & bitVal

            if (check != 0) {
                bitsArray[j] = "1"
            }
        }
        return bitsArray
    }
}

public extension Data {
    func toBitArray() -> [String] {
        var toReturn = [String]()
        for num: UInt8 in bytes {

            toReturn.append(contentsOf: num.stringBits())
        }
        return toReturn
    }
}
