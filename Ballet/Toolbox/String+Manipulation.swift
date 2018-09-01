//
//  String+Manipulation.swift
//  Ballet
//
//  Created by Koray Koska on 02.09.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension String {

    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        return String(self.dropFirst(prefix.count))
    }

    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        return String(self.dropLast(suffix.count))
    }
}
