//
//  WalletViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/17/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import Material

class WalletViewController: UIViewController {

    @IBOutlet weak var FABButton: FABButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.view.backgroundColor = Colors.background
        setupFAB()
    }
    @IBAction func FabClicked(_ sender: Any) {
    }
    
    func setupFAB() {
        FABButton.backgroundColor = Colors.secondaryColor
        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.white)
        FABButton.setImage(image, for: .normal)
    }
}
