//
//  ReciveViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/20/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit

class ReciveViewController: UIViewController {

    @IBOutlet weak var QRImageview: UIImageView!
    var qrcodeImage: CIImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
}
