//
//  SendEtherQRCode.swift
//  Ballet
//
//  Created by Ben Koska on 12/27/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit

class EtherQRCode {

    var address: String = ""
    var value: Decimal = Decimal(floatLiteral: 1.0)
    var gas: Int = 21000

    init(address: String, value: Decimal, gas: Int = 21000) {
        self.address = address
        self.value = value
        self.gas = gas
    }

    /**
     *
     * Get Data encoded for QR Code
     *
     * - returns: Address, Ether Value and Gas encoded as Data using Ether QR Code Standard
     */
    private func getEncodedQRData() -> Data {
            /*
                Example: ethereum:0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8?value=1&gas=42000

                Breakup:
                ethereum:0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8
                ?
                value=1
                &
                gas=42000
            */
            let optData = "ethereum:\(self.address)?value=\(self.value)&gas=\(self.gas)".data(using: String.Encoding.utf8, allowLossyConversion: false)
            if let data = optData {
                return data
            }else{
                return Data()
            }
    }

    static func decodeDataForRecive(data: String) -> EtherTransaction? {
        // Example: ethereum:0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8?value=1&gas=42000
        return EtherTransaction(address: "0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8", value: 1, gas: 42000)
    }

    func generate() -> UIImage{
        let data = getEncodedQRData()

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("L", forKey: "inputCorrectionLevel")

            let transform = CGAffineTransform(scaleX: 5, y: 5)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return UIImage()
    }
}

