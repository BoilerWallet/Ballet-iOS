//
//  ETHGasStation.swift
//  Ballet
//
//  Created by Koray Koska on 02.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct ETHGasStation {

    static func getGasPrice(completion: @escaping ((_ gasPrice: ETHGasStationGasPrice?, _ error: Error?) -> Void)) {
        Alamofire.request(
            "https://ethgasstation.info/json/ethgasAPI.json",
            method: .get,
            headers: ["Accept": "application/json"]
        ).responseData { response in
            guard let data = response.result.value else {
                completion(nil, response.error)
                return
            }

            do {
                let json = try JSONDecoder().decode(ETHGasStationGasPrice.self, from: data)
                completion(json, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    static func getGasPrice() -> Promise<ETHGasStationGasPrice> {
        return Promise { seal in
            ETHGasStation.getGasPrice(completion: { (gasPrice, error) in
                seal.resolve(gasPrice, error)
            })
        }
    }

    static func getGasPrice(for rpcUrl: RPCUrl) -> Promise<ETHGasStationGasPrice> {
        if rpcUrl.isMainnet {
            return ETHGasStation.getGasPrice()
        }

        return Promise { seal in
            let gasPrice = ETHGasStationGasPrice(
                fastWait: 0,
                speed: 0,
                averageCalc: 0,
                fast: 50,
                avgWait: 0,
                averageTxpool: 0,
                safelowCalc: 0,
                safeLowWait: 0,
                blockNum: 0,
                fastestWait: 0,
                safelowTxpool: 0,
                fastest: 200,
                average: 21,
                safeLow: 0,
                blockTime: 0
            )
            seal.fulfill(gasPrice)
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
