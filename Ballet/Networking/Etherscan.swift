//
//  Etherscan.swift
//  Ballet
//
//  Created by Koray Koska on 05.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Web3
import BigInt

struct Etherscan {

    enum Error: Swift.Error {

        case etherscanUrlNotAvailable
    }

    let rpcUrl: RPCUrl

    init(rpcUrl: RPCUrl) {
        self.rpcUrl = rpcUrl
    }

    func getTransactions(
        for address: EthereumAddress,
        page: Int = 1,
        size: Int = 10,
        order: OrderType = .ascending,
        completion: @escaping ((_ txs: [EtherscanTransaction]?, _ error: Swift.Error?) -> Void)
    ) {
        guard let etherscanUrl = rpcUrl.etherscanApiUrl else {
            completion(nil, Error.etherscanUrlNotAvailable)
            return
        }

        let parameters: Parameters = [
            "module": "account",
            "action": "txlist",
            "address": address.hex(eip55: false),
            "page": "\(page)",
            "offset": "\(size)",
            "sort": "\(order.rawValue)",
            "apikey": "PRH62S7HN4XPSUXBIXF9HZATS3UVSC6BFY"
        ]
        Alamofire.request(
            "\(etherscanUrl)/api",
            method: .get,
            parameters: parameters,
            headers: ["Accept": "application/json"]
        ).responseData { response in
            guard let data = response.result.value else {
                completion(nil, response.error)
                return
            }

            do {
                let json = try JSONDecoder().decode(EtherscanTransactionResponse.self, from: data)

                var hashes: [String: Bool] = [:]
                let array = json.result.filter { obj in
                    let hex = obj.hash.hex()
                    if let b = hashes[hex], b {
                        return false
                    } else {
                        hashes[hex] = true
                        return true
                    }
                }
                completion(array, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    func getTransactions(
        for address: EthereumAddress,
        page: Int = 1,
        size: Int = 10,
        order: OrderType = .ascending
    ) -> Promise<[EtherscanTransaction]> {
        return Promise { seal in
            getTransactions(for: address, page: page, size: size, order: order) { result, error in
                seal.resolve(result, error)
            }
        }
    }

    enum OrderType: String {

        case ascending = "asc"
        case descending = "desc"
    }
}

struct EtherscanTransactionResponse: Codable {

    let status: EthereumDecimalBigIntValue
    let message: String
    let result: [EtherscanTransaction]
}

struct EtherscanTransaction: Codable {

    let blockNumber: EthereumDecimalBigIntValue
    let timeStamp: EthereumDecimalBigIntValue
    let hash: EthereumData
    let nonce: EthereumDecimalBigIntValue
    let blockHash: EthereumData
    let transactionIndex: EthereumDecimalBigIntValue
    let from: EthereumAddress
    let to: EthereumAddress
    let value: EthereumDecimalBigIntValue
    let gas: EthereumDecimalBigIntValue
    let gasPrice: EthereumDecimalBigIntValue
    let isError: EthereumDecimalBigIntValue
    let txreceipt_status: String
    let input: EthereumData
    let contractAddress: EthereumData
    let cumulativeGasUsed: EthereumDecimalBigIntValue
    let gasUsed: EthereumDecimalBigIntValue
    let confirmations: EthereumDecimalBigIntValue
}

struct EthereumDecimalBigIntValue: EthereumValueConvertible {

    let intValue: BigInt

    init(intValue: BigInt) {
        self.intValue = intValue
    }

    init(ethereumValue: EthereumValue) throws {
        guard let str = ethereumValue.string, let i = BigInt(str, radix: 10) else {
            throw EthereumValueInitializableError.notInitializable
        }

        self.init(intValue: i)
    }

    func ethereumValue() -> EthereumValue {
        return .string(String(intValue, radix: 10))
    }
}
