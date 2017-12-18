//
//  ConstantHolder
//  Ballet
//
//  Created by Ben Koksa on 12/18/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit

class ConstantHolder {
    static let primaryColor: UIColor = UIColor(displayP3Red: 86/255, green: 86/255, blue: 86/255, alpha: 1)
    static let secondaryColor: UIColor = UIColor(displayP3Red: 42/255, green: 240/255, blue: 253/255, alpha: 1)
    static let white: UIColor = UIColor.white
    
    static func primaryColorWAlpha(alpha: Float) -> UIColor {
        return UIColor(displayP3Red: 86/255, green: 86/255, blue: 86/255, alpha: CGFloat(alpha))
    }
    
    static func secondaryColorWAlpha(alpha: Float) -> UIColor {
        return UIColor(displayP3Red: 42/255, green: 240/255, blue: 253/255, alpha: CGFloat(alpha))
    }
}
