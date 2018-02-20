//
//  LoadingIndicator.swift
//  Ballet
//
//  Created by Koray Koska on 20.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Cartography

class LoadingIndicator: UIView {

    private var sectionConstraintGroup: ConstraintGroup = .init()
    private var sections: [LoadingIndicatorSection] = []
    private var sectionContainers: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        // startSectionAnimations()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = UIColor.clear
        isOpaque = false

        for v in sectionContainers {
            v.removeFromSuperview()
        }
        sectionContainers = [UIView(), UIView(), UIView(), UIView()]
        for v in sectionContainers {
            self.addSubview(v)
        }

        var containers = sectionContainers
        containers.insert(self, at: 0)
        constrain(containers) { views in
            let container = views[0]
            let sec1 = views[1]
            let sec2 = views[2]
            let sec3 = views[3]
            let sec4 = views[4]

            sec1.width == container.width / 4 - 10
            sec1.height == sec1.width
            sec1.centerY == container.centerY
            sec1.left == container.left + 8

            sec2.width == container.width / 4 - 10
            sec2.height == sec2.width
            sec2.centerY == container.centerY
            sec2.left == sec1.right + 8

            sec3.width == container.width / 4 - 10
            sec3.height == sec3.width
            sec3.centerY == container.centerY
            sec3.left == sec2.right + 8

            sec4.width == container.width / 4 - 10
            sec4.height == sec4.width
            sec4.centerY == container.centerY
            sec4.left == sec3.right + 8
        }

        let sec1 = LoadingIndicatorSection()
        sec1.fillColor = UIColor.green
        let sec2 = LoadingIndicatorSection()
        sec2.fillColor = UIColor.red
        let sec3 = LoadingIndicatorSection()
        sec3.fillColor = UIColor.purple
        let sec4 = LoadingIndicatorSection()
        sec4.fillColor = UIColor.darkGray

        sectionContainers[0].addSubview(sec1)
        sectionContainers[1].addSubview(sec2)
        sectionContainers[2].addSubview(sec3)
        sectionContainers[3].addSubview(sec4)

        sections = [sec1, sec2, sec3, sec4]

        setInitialSectionConstraints()
        setSectionsConstraints()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 1000000000)) {
            self.startSectionAnimations()
        }
    }

    private func setInitialSectionConstraints() {
        var views: [UIView] = []
        for v in sections {
            views.append(v)
        }
        for v in sectionContainers {
            views.append(v)
        }
        guard views.count == 8 else {
            return
        }

        constrain(views) { views in
            for i in 0..<4 {
                let section = views[i]
                let container = views[4 + i]

                section.center == container.center
            }
        }
    }

    private func setSectionsConstraints(scale: CGFloat = 1, animationDuration: TimeInterval = 0) {
        var views: [UIView] = []
        for v in sections {
            views.append(v)
        }
        for v in sectionContainers {
            views.append(v)
        }
        guard views.count == 8 else {
            return
        }

        sectionConstraintGroup = constrain(views, replace: sectionConstraintGroup) { views in
            for i in 0..<4 {
                let section = views[i]
                let container = views[4 + i]

                section.width == container.width * scale
                section.height == container.height * scale
            }
        }
        for v in sections {
            v.setNeedsUpdateConstraints()
        }

        UIView.animate(withDuration: animationDuration) {
            for v in self.sections {
                v.layoutIfNeeded()
            }
        }
    }

    // MARK: - Animation helpers

    private func startSectionAnimations() {
        DispatchQueue(label: "LoadingAnimator").async { [weak self] in
            while true {
                guard let s = self else {
                    break
                }
                DispatchQueue.main.sync {
                    s.setSectionsConstraints(scale: 0.25, animationDuration: 5)
                }
                usleep(250000)
                break
            }
        }
    }
}

@IBDesignable
class LoadingIndicatorSection: UIView {

    @IBInspectable
    var fillColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.clear
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath(ovalIn: rect)
        (fillColor ?? UIColor.clear).setFill()
        path.fill()
    }
}
