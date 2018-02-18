//
//  LabelExtension.swift
//  Ballet
//
//  Created by Ben Koska on 12/21/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import Foundation
import Material

extension UILabel {

    /**
     * Setup the  title label as stated in the Material Design Guidelines with the default font size of 16
     */
    func setupTitleLabel() {
        self.font = RobotoFont.regular(with: 16)
        self.textColor = Color.black.withAlphaComponent(0.87)
        self.adjustsFontSizeToFitWidth = false
        self.lineBreakMode = .byTruncatingTail
    }

    /**
     * Setup the  title label as stated in the Material Design Guidelines with the given size as the font size
     *
     * - parameter size: The font size
     */
    func setupTitleLabelWithSize(size: CGFloat) {
        self.font = RobotoFont.regular(with: size)
        self.textColor = Color.black.withAlphaComponent(0.87)
        self.adjustsFontSizeToFitWidth = false
        self.lineBreakMode = .byTruncatingTail
    }

    /**
     * Setup the  subtitle label as stated in the Material Design Guidelines with the default font size of 14
     */
    func setupSubTitleLabel() {
        self.font = RobotoFont.regular(with: 14)
        self.textColor = Color.black.withAlphaComponent(0.54)
        self.adjustsFontSizeToFitWidth = false
        self.lineBreakMode = .byTruncatingTail
    }

    /**
     * Setup the  subtitle label as stated in the Material Design Guidelines with the given size as the font size
     *
     * - parameter size: The font size
     */
    func setupSubTitleLabelWithSize(size: CGFloat) {
        self.font = RobotoFont.regular(with: size)
        self.textColor = Color.black.withAlphaComponent(0.54)
        self.adjustsFontSizeToFitWidth = false
        self.lineBreakMode = .byTruncatingTail
    }

    /**
     Setup the  body label as stated in the Material Design Guidelines with the default font size of 14
     */
    func setupBodyLabel() {
        self.font = RobotoFont.regular(with: 14)
        self.textColor = Color.black.withAlphaComponent(0.54)
        self.sizeToFit()
    }

    /**
     * Setup the  body label as stated in the Material Design Guidelines with the given size as the font size
     *
     * - parameter size: The font size
     */
    func setupBodyLabelWithSize(size: CGFloat) {
        self.font = RobotoFont.regular(with: size)
        self.textColor = Color.black.withAlphaComponent(0.54)
        self.sizeToFit()
    }
}
