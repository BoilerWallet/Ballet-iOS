//
//  Button+MaterialDefault.swift
//  Ballet
//
//  Created by Koray Koska on 22.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Material

extension RaisedButton {

    func setupProjectDefault() {
        backgroundColor = Colors.accent.base
        titleColor = Colors.lightPrimaryTextColor
        pulseColor = Color.black.withAlphaComponent(0.12)
    }

    func setupProjectDefaultDisabled() {
        backgroundColor = Color.black.withAlphaComponent(0.12)
        titleColor = Color.black.withAlphaComponent(0.26)
    }
}
