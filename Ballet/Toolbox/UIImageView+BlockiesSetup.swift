//
//  UIImageView+BlockiesSetup.swift
//  Ballet
//
//  Created by Koray Koska on 01.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import BlockiesSwift

extension UIImageView {

    func setBlockies(with seed: String) {
        let scale = Int(ceil((bounds.width * bounds.height) / 24))
        DispatchQueue.global().async { [weak self] in
            let blockies = Blockies(seed: seed, size: 8, scale: 3).createImageCached()
            let blockie = scale > 3 ? scale > 4 ? blockies?.high : blockies?.medium : blockies?.low

            DispatchQueue.main.sync { [weak self] in
                self?.image = blockie
            }
        }
    }
}
