//
//  Blockies+Cached.swift
//  Ballet
//
//  Created by Koray Koska on 27.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BlockiesSwift

private var cachedBlockies: [String: (low: UIImage, medium: UIImage, high: UIImage)] = [:]

extension Blockies {

    /**
     * Creates and caches an image with this Blockies.
     *
     * Don't use this function with custom colors as this would break caching.
     */
    func createImageCached() -> (low: UIImage, medium: UIImage, high: UIImage)? {
        if let cached = cachedBlockies["\(seed)--\(size)--\(scale)"] {
            return cached
        }

        guard let imageLow = createImage(customScale: 3),
            let imageMedium = createImage(customScale: 4),
            let imageHigh = createImage(customScale: 5) else {
            return nil
        }

        cachedBlockies["\(seed)--\(size)--\(scale)"] = (imageLow, imageMedium, imageHigh)

        return (imageLow, imageMedium, imageHigh)
    }
}
