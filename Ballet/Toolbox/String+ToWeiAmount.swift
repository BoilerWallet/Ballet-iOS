//
//  String+ToWeiAmount.swift
//  Ballet
//
//  Created by Koray Koska on 02.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

extension String {

    func ethToWei() -> BigInt? {
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

        return BigInt(weiAmount, radix: 10)
    }
}
