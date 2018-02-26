//
//  EthereumQuantity+ConvertFromWei.swift
//  Ballet
//
//  Created by Koray Koska on 26.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Web3
import BigInt

extension EthereumQuantity {

    func convertWeiToEthString() -> String {
        let first = quantity.quotientAndRemainder(dividingBy: BigUInt(10).power(18))
        var value = String(first.quotient) + "."
        var remainder = first.remainder
        for i in (0..<18).reversed() {
            let current = remainder.quotientAndRemainder(dividingBy: BigUInt(10).power(i))

            value += String(current.quotient)
            remainder = current.remainder
        }

        return value
    }
}
