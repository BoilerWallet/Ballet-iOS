//
//  Promise+UnwrapOptional.swift
//  Ballet
//
//  Created by Koray Koska on 04.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import PromiseKit

func unwrap<T>(_ optional: Optional<T>, throwable: Error = OptionalUnwrapError.optionalNil) -> Promise<T> {
    return Promise { seal in
        if let value = optional {
            seal.fulfill(value)
        } else {
            seal.reject(throwable)
        }
    }
}

enum OptionalUnwrapError: Error {

    case optionalNil
}
