//
//  ReceiveViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit

class ReceiveViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var QRImageview: UIImageView!

    var qrcodeImage: CIImage = CIImage()

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        // TODO: Fetch Public Key from DB
        let publickey = Values.defaultAccount.public_key

        let data = publickey.data(using: String.Encoding.utf8, allowLossyConversion: false)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("L", forKey: "inputCorrectionLevel")

            let transform = CGAffineTransform(scaleX: 5, y: 5)

            if let output = filter.outputImage?.transformed(by: transform) {
                QRImageview.image = UIImage(ciImage: output)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        // TabBar
        prepareTabItem()
    }
}

// MARK: - TabBar

extension ReceiveViewController {

    fileprivate func prepareTabItem() {
        // tabItem.title = "Receive"
        tabItem.image = UIImage(named: "ic_call_received")?.withRenderingMode(.alwaysTemplate)
    }
}
