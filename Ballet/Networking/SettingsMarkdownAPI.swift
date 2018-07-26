//
//  SettingsMarkdownAPI.swift
//  Ballet
//
//  Created by Koray Koska on 26.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct SettingsMarkdownAPI {

    static let openSourceLibrariesRoute = "https://storage.googleapis.com/boilertalk/Ballet/OpenSourceLibraries.md"

    static func getOpenSourceLibraries(completion: @escaping ((_ data: Data?, _ error: Error?) -> Void)) {
        Alamofire.request(openSourceLibrariesRoute, method: .get).responseData { response in
            guard let data = response.result.value else {
                completion(nil, response.error)
                return
            }

            completion(data, nil)
        }
    }

    static func getOpenSourceLibraries() -> Promise<Data> {
        return Promise { seal in
            getOpenSourceLibraries(completion: seal.resolve)
        }
    }
}
