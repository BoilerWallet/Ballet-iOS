//
//  BottomSheetElement.swift
//  Ballet
//
//  Created by Koray Koska on 24.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Cartography
import MaterialComponents.MDCInkView

@IBDesignable
class BottomSheetElement: UIView {

    // MARK: - Properties

    @IBInspectable var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage?.withRenderingMode(.alwaysTemplate)
        }
    }

    @IBInspectable var text: String? = "Label" {
        didSet {
            textLabel.text = text
        }
    }

    var onClick: (() -> ())?

    private var inkView: MDCInkTouchController!

    private var iconImageView: UIImageView!
    private var textLabel: UILabel!

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
        setupUI()
    }

    // MARK: - UI setup

    private func setupUI() {
        inkView = MDCInkTouchController(view: self)
        inkView.addInkView()

        iconImageView = UIImageView()
        textLabel = UILabel()

        addSubview(iconImageView)
        addSubview(textLabel)

        constrain(self, iconImageView, textLabel) { container, icon, text in
            icon.width == 24
            icon.height == 24
            icon.centerY == container.centerY
            icon.left == container.left + 16

            text.height == 24
            text.centerY == container.centerY
            text.left == icon.right + 16
            text.right == container.right - 16
        }

        iconImageView.tintColor = Colors.darkSecondaryTextColor
        iconImageView.image = iconImage?.withRenderingMode(.alwaysTemplate)

        textLabel.setupSubTitleLabel()
        textLabel.text = text

        // Touch actions
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clicked)))
    }

    // MARK: - Actions

    @objc private func clicked() {
        onClick?()
    }
}
