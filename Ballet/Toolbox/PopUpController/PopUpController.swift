//
//  PopUpController.swift
//  Ballet
//
//  Created by Koray Koska on 19.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Cartography

class PopUpController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cardView: UIView!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
    }

    // MARK: - UI setup

    private func setupUI() {
        // Transparent background
        view.backgroundColor = UIColor.clear
        view.isOpaque = false

        backgroundView.backgroundColor = Colors.darkSecondaryTextColor.withAlphaComponent(0.28)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissButtonClicked)))

        // Motion
        isMotionEnabled = true
        cardView.motionIdentifier = "PopUpCreation"
    }

    // MARK: - Actions

    @objc private func dismissButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PopUpController {

    static func instantiate(from: UIViewController, with: UIViewController) {
        guard let popUp = UIStoryboard(name: "PopUpController", bundle: nil).instantiateInitialViewController() as? PopUpController else {
            return
        }

        // Make sure motion animation is enabled
        from.isMotionEnabled = true

        // Create centered clear view for a nice animation
        let invisible = View()
        invisible.backgroundColor = UIColor.clear
        from.view.addSubview(invisible)
        constrain(from.view, invisible) { view, invisible in
            invisible.width == 56
            invisible.height == 56
            invisible.centerX == view.centerX
            invisible.centerY == view.centerY
        }

        invisible.motionIdentifier = "PopUpCreation"
        invisible.shapePreset = .circle

        popUp.modalPresentationStyle = .overFullScreen
        from.present(popUp, animated: true, completion: nil)

        // Embed controller into CardView
        popUp.addChildViewController(with)
        popUp.cardView.addSubview(with.view)
        constrain(popUp.cardView, with.view) { cardView, embedded in
            embedded.top == cardView.top
            embedded.bottom == cardView.bottom
            embedded.left == cardView.left
            embedded.right == cardView.right
        }
        with.didMove(toParentViewController: popUp)
    }
}
