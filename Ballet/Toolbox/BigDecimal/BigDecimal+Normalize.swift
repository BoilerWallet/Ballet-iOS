//
//  BigDecimal+Normalize.swift
//  Ballet
//
//  Created by Koray Koska on 20.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Runes

extension BigDecimal {

    func normalizeZeros() -> BigDecimal {
        var newVal = self

        while let str: String = pure(String(newVal.significand, radix: 10)), str.last == "0", str.count > 1 {
            newVal = BigDecimal(sign: newVal.sign, exponent: newVal.exponent + 1, significand: newVal.significand / 10, precision: newVal.precision)
        }

        return newVal
    }
}

extension BigUDecimal {

    func normalizeZeros() -> BigUDecimal {
        return BigUDecimal(absolute: BigDecimal(from: self).normalizeZeros())
    }
}
