//
//  Account.swift
//  Ballet
//
//  Created by Ben Koksa on 12/25/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import Foundation
import UIKit
import BlockiesSwift

class Account {
    var public_key: String
    var name: String
    var wei: Decimal
    
    init (public_key: String, name: String, wei: Decimal) {
        self.public_key = public_key
        self.name = name
        self.wei = wei
    }
    
    func asTxtMsg() -> String{
        return "\(self.name) - \(self.wei / Values.weiPerEther) ETH"
    }
    /**
     Generate Blockie with Custom Size
     
     - Parameter size: Base Size of Image
     - Parameter scale: Scale the Base Size
     
     - Returns: returns blockie for the account with the size of size `*` scale as UIImage
     */
    func getBlockie(size: Int, scale: Int) -> UIImage{
        // Generate Blockie
        let blockie = Blockies(seed: self.public_key, size: size, scale: scale)
        
        if let blockieimg = blockie.createImage() {
            return blockieimg
        }else{
            // Could not generate blockie
            return UIImage()
        }
    }
}
