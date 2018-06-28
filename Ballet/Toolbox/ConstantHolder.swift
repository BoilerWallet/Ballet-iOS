//
//  ConstantHolder.swift
//  Ballet
//
//  Created by Koray Koska on 28.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

struct ConstantHolder {

    private static let passwordHashKey = "passwordHash"

    static var passwordHash: String? {
        get {
            return UserDefaults.standard.string(forKey: passwordHashKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: passwordHashKey)
        }
    }

    private static let passwordSaltKey = "passwordSaltKey"

    static var passwordSalt: String? {
        get {
            return UserDefaults.standard.string(forKey: passwordSaltKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: passwordSaltKey)
        }
    }
}
