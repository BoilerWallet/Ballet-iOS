//
//  BigDecimal+StringInit.swift
//  Ballet
//
//  Created by Koray Koska on 20.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt
import Runes

extension BigDecimal {

    /// Initializes a `BigDecimal` from the given string if possible.
    ///
    /// Possible formattings are all of the following:
    ///
    /// ```
    /// 123.456
    /// +123.456
    /// -123.456
    ///
    /// 123,456
    /// +123,456
    /// -123,456
    /// ```
    ///
    /// - parameter string: The string to convert,
    ///
    /// - returns: The initialized instance of `BigDecimal` or nil.
    public init?(string: String) {
        var string = string.replacingOccurrences(of: ",", with: ".")

        let sign: FloatingPointSign
        if string.count > 0 && string[string.startIndex] == "-" {
            sign = .minus
            string = String(string[string.index(string.startIndex, offsetBy: 1)...])
        } else if string.count > 0 && string[string.startIndex] == "+" {
            sign = .plus
            string = String(string[string.index(string.startIndex, offsetBy: 1)...])
        } else {
            sign = .plus
        }

        var splitted = string.split(separator: ".")
        guard splitted.count <= 2 else {
            return nil
        }

        // If string starts with a dot, we have to manipulate the splitted array
        if string.hasPrefix(".") && splitted.count == 1 {
            splitted = [
                Substring(),
                splitted[0]
            ]
        }

        let exponent = -1 * (splitted.count > 1 ? splitted[1].count : 0)
        var significand: BigUInt = 0

        var significandExponent = 0

        let increaseSignificand: (String) -> Bool = { allDigits in
            for i in 0..<allDigits.count {
                let index = allDigits.index(allDigits.endIndex, offsetBy: (-1 * i) - 1)
                guard let digit = Int(String(allDigits[index])) else {
                    return false
                }

                significand = significand + (BigUInt(10).power(significandExponent) * BigUInt(digit))
                significandExponent += 1
            }
            return true
        }

        if splitted.count > 1 {
            let allDigits = String(splitted[1])

            if !increaseSignificand(allDigits) {
                return nil
            }
        }

        if splitted.count > 0 {
            let allDigits = String(splitted[0])

            if !increaseSignificand(allDigits) {
                return nil
            }
        }

        self.init(sign: sign, exponent: exponent, significand: significand)
    }
}

extension BigUDecimal {

    /// Initializes a `BigUDecimal` from the given string if possible.
    ///
    /// Possible formattings are all of the following:
    ///
    /// ```
    /// 123.456
    /// +123.456
    ///
    /// 123,456
    /// +123,456
    /// ```
    ///
    /// - parameter string: The string to convert,
    ///
    /// - returns: The initialized instance of `BigUDecimal` or nil.
    public init?(string: String) {
        if string.first == "-" {
            return nil
        }

        guard let val = BigUDecimal.init <^> BigDecimal(string: string) else {
            return nil
        }

        self = val
    }
}
