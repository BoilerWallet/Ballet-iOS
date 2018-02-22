//
//  LoadingView.swift
//  Ballet
//
//  Created by Koray Koska on 20.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Lottie
import Cartography

class LoadingView: UIView {

    // MARK: - Properties

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    private(set) var blurView: UIView?

    private(set) var loadingView: LOTAnimationView!

    private(set) var loading: Bool = false

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
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    // MARK: - Animation helpers

    func startLoading() {
        loading = true
        loadingView.isHidden = false
        blurView?.removeFromSuperview()

        // let blur = UIBlurEffect(style: .light)
        // blurView = UIVisualEffectView(effect: blur)
        blurView = UIView()
        blurView?.backgroundColor = Colors.darkSecondaryTextColor.withAlphaComponent(0.56)
        blurView?.isOpaque = false

        guard let bv = blurView else {
            return
        }

        backgroundView.insertSubview(bv, belowSubview: loadingView)

        constrain(backgroundView, bv) { bg, blur in
            blur.left == bg.left
            blur.right == bg.right
            blur.top == bg.top
            blur.bottom == bg.bottom
        }

        playLoadingView(finished: false)
    }

    func stopLoading() {
        loading = false
        loadingView.isHidden = true
        blurView?.removeFromSuperview()
    }

    // MARK: - UI Setup

    private func setupUI() {
        // Background
        contentView.backgroundColor = UIColor.clear
        contentView.isOpaque = false

        backgroundView.backgroundColor = UIColor.clear
        backgroundView.isOpaque = false

        // Loading animation
        loadingView = LOTAnimationView(name: "material_loading_jump")
        backgroundView.addSubview(loadingView)

        constrain(backgroundView, loadingView) { background, loading in
            loading.center == background.center
            loading.width == background.width / 3
            loading.height == loading.width
        }

        // Stop animation
        stopLoading()
    }

    private func playLoadingView(finished: Bool) {
        if loading {
            loadingView.play(completion: playLoadingView)
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
