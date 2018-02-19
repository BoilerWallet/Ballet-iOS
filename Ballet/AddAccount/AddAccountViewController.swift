//
//  AddAccountViewController.swift
//  Ballet
//
//  Created by Koray Koska on 19.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material

class AddAccountViewController: UIViewController {

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

        setupToolbar()

        // Motion
        isMotionEnabled = true
        // motionTransitionType = .autoReverse(presenting: .zoom)
        cardView.motionIdentifier = "AddAccount"
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Add Account"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor

        let dismiss = IconButton(image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), tintColor: Colors.lightPrimaryTextColor)
        dismiss.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)

        navigationItem.leftViews = [dismiss]
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
