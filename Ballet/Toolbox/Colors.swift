//
//  Colors.swift
//  Ballet
//
//  Created by Koray Koska on 18.12.17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit

struct Colors {

    /// The primary color of this application as defined by Material Design
    static let primaryColor: UIColor = UIColor(displayP3Red: 86/255, green: 86/255, blue: 86/255, alpha: 1)

    /// The secondary color of this application as defined by Material Design
    static let secondaryColor: UIColor = UIColor(displayP3Red: 42/255, green: 240/255, blue: 253/255, alpha: 1)

    /// White
    static let white: UIColor = UIColor.white
    
    /// Light Grey
    static let lightGrey = UIColor(red:0.92, green:0.92, blue:0.95, alpha: 1)
    
    /// Background Color
    static let background = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1)

    /// Primary color with the given alpha value
    static func primaryColorWAlpha(alpha: Float) -> UIColor {
        return primaryColor.withAlphaComponent(CGFloat(alpha))
    }

    /// Secondary color with the given alpha value
    static func secondaryColorWAlpha(alpha: Float) -> UIColor {
        return secondaryColor.withAlphaComponent(CGFloat(alpha))
    }
    
    /// Light Grey with the given alpha value
    static func lightGreyWAlpha(alpha: Float) -> UIColor {
        return lightGrey.withAlphaComponent(CGFloat(alpha))
    }
}
