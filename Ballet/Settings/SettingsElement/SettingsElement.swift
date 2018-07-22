//
//  SettingsElement.swift
//  Ballet
//
//  Created by Koray Koska on 22.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Cartography
import MaterialComponents.MDCInkView

@IBDesignable
class SettingsElement: UIView {

    // MARK: - Properties

    @IBInspectable var titleText: String? = "Label" {
        didSet {
            titleLabel.text = titleText
        }
    }

    @IBInspectable var subtitleText: String? = "Label" {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }

    var onClick: (() -> ())?

    private var inkView: MDCInkTouchController!

    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!

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

        titleLabel = UILabel()
        subtitleLabel = UILabel()

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        constrain(self, titleLabel, subtitleLabel) { container, title, subtitle in
            title.height == 24
            title.left == container.left + 16
            title.top == container.top + 16
            title.right == container.right - 16

            subtitle.height == 24
            subtitle.top == title.bottom
            subtitle.left == container.left + 16
            subtitle.right == container.right - 16
        }

        titleLabel.setupTitleLabel()
        titleLabel.text = titleText

        subtitleLabel.setupSubTitleLabel()
        subtitleLabel.text = subtitleText

        // Touch actions
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clicked)))
    }

    // MARK: - Actions

    @objc private func clicked() {
        onClick?()
    }
}
