//
//  Dialog+Defaults.swift
//  Ballet
//
//  Created by Koray Koska on 25.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension DialogBuilder where T == DialogView {

    static func selectedNetwork(for url: RPCUrl) -> Dialog {
        let title = url.name
        let text = "You are currently in the network \"\(url.name)\". To switch visit the Settings menu."

        return Dialog().title(title).details(text).positive("OK", handler: nil)
    }
}
