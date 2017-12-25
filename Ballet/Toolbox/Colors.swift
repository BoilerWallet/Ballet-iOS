//
//  Colors.swift
//  Ballet
//
//  Created by Koray Koska on 18.12.17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

struct Colors {

    /// The primary color of this application as defined by Material Design
    static let primaryColor = Color.cyan.base

    /// The secondary color of this application as defined by Material Design
    static let secondaryColor = Color.pink.base

    /// White
    static let white: UIColor = UIColor.white

    /// Light Grey
    static let lightGrey = UIColor(red:0.92, green:0.92, blue:0.95, alpha: 1)

    /// Background Color
    static let background = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)

    // Font colors
    static let darkPrimaryTextColor = Color.black.withAlphaComponent(0.87)
    static let darkSecondaryTextColor = Color.black.withAlphaComponent(0.54)
    static let darkDisabledTextColor = Color.black.withAlphaComponent(0.38)
    static let darkDividerColor = Color.black.withAlphaComponent(0.12)

    static let lightPrimaryTextColor = Color.white.withAlphaComponent(1.0)
    static let lightSecondaryTextColor = Color.white.withAlphaComponent(0.7)
    static let lightDisabledTextColor = Color.white.withAlphaComponent(0.5)
    static let lightDividerColor = Color.white.withAlphaComponent(0.12)

    static let navigationItemLabelColor = Color.black.withAlphaComponent(0.87)
    // End Font colors
}
