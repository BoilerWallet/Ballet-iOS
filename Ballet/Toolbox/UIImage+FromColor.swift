//
//  UIImage+FromColor.swift
//  Ballet
//
//  Created by Koray Koska on 20.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit

extension UIImage {

    static func from(color: UIColor, width: CGFloat = 10, height: CGFloat = 10) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
    }
}
