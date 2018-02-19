//
//  AddAccountViewController.swift
//  Ballet
//
//  Created by Koray Koska on 19.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import Web3
import Cartography
import BlockiesSwift
import AlamofireImage

class AddAccountViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var cardView: UIView!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        showSelection()
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

    private func showSelection() {
        var accounts = [EthereumPrivateKey]()
        for _ in 0..<6 {
            try? accounts.append(EthereumPrivateKey())
        }
        guard accounts.count == 6 else {
            // TODO: Error handling
            return
        }

        let container = View()
        cardView.addSubview(container)

        constrain(cardView, container) { cardView, container in
            container.left == cardView.left
            container.right == cardView.right
            container.top == cardView.top
            container.height == 2 * cardView.width / 3
        }

        let rowOne = View()
        container.addSubview(rowOne)
        let rowTwo = View()
        container.addSubview(rowTwo)

        constrain(container, rowOne, rowTwo) { container, rowOne, rowTwo in
            rowOne.left == container.left
            rowOne.right == container.right
            rowOne.top == container.top
            rowOne.height == container.height / 2

            rowTwo.left == container.left
            rowTwo.right == container.right
            rowTwo.top == rowOne.bottom
            rowTwo.height == container.height / 2
        }

        for i in 0..<2 {
            let row = i == 0 ? rowOne : rowTwo
            let first = View()
            let second = View()
            let third = View()
            row.addSubview(first)
            row.addSubview(second)
            row.addSubview(third)

            constrain(row, first, second, third, block: { row, first, second, third in
                first.width == row.width / 3 - 16
                first.height == row.height - 16
                first.centerY == row.centerY
                first.left == row.left + 12

                second.width == row.width / 3 - 16
                second.height == row.height - 16
                second.centerY == row.centerY
                second.left == first.right + 12

                third.width == row.width / 3 - 16
                third.height == row.height - 16
                third.centerY == row.centerY
                third.left == second.right + 12
            })

            let imageRow = [first, second, third]
            for j in 0..<imageRow.count {
                let imageView = UIImageView()
                imageRow[j].addSubview(imageView)
                constrain(imageRow[j], imageView, block: { container, imageView in
                    imageView.width == container.width
                    imageView.height == container.height
                    imageView.center == container.center
                })
                imageView.image = Blockies(seed: accounts[i * 3 + j].address.hex(eip55: false), size: 8, scale: 3).createImage(customScale: 8)?.af_imageRounded(withCornerRadius: 50)
            }
        }
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
