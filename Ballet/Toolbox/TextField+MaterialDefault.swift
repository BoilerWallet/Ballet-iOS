//
//  TextField+MaterialDefault.swift
//  Ballet
//
//  Created by Koray Koska on 22.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Material

extension TextField {

    func setupProjectDefault() {
        dividerNormalColor = Color.black.withAlphaComponent(0.42)
        dividerActiveColor = Colors.primary.darken2
        placeholderNormalColor = Color.black.withAlphaComponent(0.54)
        placeholderActiveColor = Colors.primary.darken2.withAlphaComponent(0.87)
        detailColor = Color.black.withAlphaComponent(0.54)
    }
}
