//
//  ReceiveViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class ReceiveViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var qrImageview: UIImageView!

    var qrcodeImage: CIImage = CIImage()

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        qrImageview.image = EtherQRCode(address: Values.defaultAccount.public_key, value: 1.0).generate()
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
