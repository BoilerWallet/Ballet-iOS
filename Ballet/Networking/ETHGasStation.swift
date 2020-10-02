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
        AF.request(
            "https://ethgasstation.info/json/ethgasAPI.json",
            method: .get,
            headers: ["Accept": "application/json"]
        ).responseData { response in
            guard let data = try? response.result.get() else {
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
                fast: 50,
                avgWait: 0,
                safeLowWait: 0,
                fastestWait: 0,
                fastest: 200,
                average: 21,
                safeLow: 0
            )
            seal.fulfill(gasPrice)
        }
    }
}

struct ETHGasStationGasPrice: Codable {

    let fastWait: Double
    let fast: Double
    let avgWait: Double
    let safeLowWait: Double
    let fastestWait: Double
    let fastest: Double
    let average: Double
    let safeLow: Double
}
