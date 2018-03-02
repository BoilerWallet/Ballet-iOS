//
//  ETHGasStation.swift
//  Ballet
//
//  Created by Koray Koska on 02.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Alamofire

struct ETHGasStation {

    static func getGasPrice(completion: @escaping ((_ success: Bool, _ gasPrice: ETHGasStationGasPrice?) -> Void)) {
        Alamofire.request(
            "https://ethgasstation.info/json/ethgasAPI.json",
            method: .get,
            headers: ["Accept": "application/json"]
        ).responseData { response in
            guard let data = response.result.value, let json = try? JSONDecoder().decode(ETHGasStationGasPrice.self, from: data) else {
                completion(false, nil)
                return
            }

            completion(true, json)
        }
    }
}

struct ETHGasStationGasPrice: Codable {

    enum CodingKeys: String, CodingKey {

        case fastWait
        case speed
        case averageCalc = "average_calc"
        case fast
        case avgWait
        case averageTxpool = "average_txpool"
        case safelowCalc = "safelow_calc"
        case safeLowWait
        case blockNum
        case fastestWait
        case safelowTxpool = "safelow_txpool"
        case fastest
        case average
        case safeLow
        case blockTime = "block_time"
    }

    let fastWait: Double
    let speed: Double
    let averageCalc: Double
    let fast: Double
    let avgWait: Double
    let averageTxpool: Double
    let safelowCalc: Double
    let safeLowWait: Double
    let blockNum: Int
    let fastestWait: Double
    let safelowTxpool: Double
    let fastest: Double
    let average: Double
    let safeLow: Double
    let blockTime: Double
}
