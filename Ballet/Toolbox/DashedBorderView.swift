//
//  DashedBorderView.swift
//  Ballet
//
//  Created by Koray Koska on 28.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit

class DashedBorderView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 4
    @IBInspectable var dashPaintedSize: Int = 2
    @IBInspectable var dashUnpaintedSize: Int = 2

    let dashedBorder = CAShapeLayer()

    private(set) var isBorderVisible = false

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        self.layer.addSublayer(dashedBorder)
    }

    // MARK: - UI setup

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        if isBorderVisible {
            applyDashBorder()
        }
    }

    func applyDashBorder() {
        isBorderVisible = true

        dashedBorder.strokeColor = borderColor?.cgColor
        dashedBorder.lineDashPattern = [NSNumber(value: dashPaintedSize), NSNumber(value: dashUnpaintedSize)]
        dashedBorder.fillColor = nil
        dashedBorder.cornerRadius = cornerRadius
        dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath

        dashedBorder.cornerRadius = self.layer.cornerRadius
        dashedBorder.masksToBounds = true

        dashedBorder.frame = self.bounds
    }

    func deleteDashBorder() {
        isBorderVisible = false

        dashedBorder.strokeColor = UIColor.clear.cgColor
    }
}
