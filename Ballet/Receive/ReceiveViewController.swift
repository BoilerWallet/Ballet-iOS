//
//  ReceiveViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material
import EIP67

class ReceiveViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var qrImageview: UIImageView!

    var qrcodeImage: CIImage = CIImage()

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        let img = EIP67QRCode(address: Values.defaultAccount.public_key).image(scale: 2.5)
        qrImageview.image = UIImage(ciImage: img)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        setupToolbar()
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Receive"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
    }
}
