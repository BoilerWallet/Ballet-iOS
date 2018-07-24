//
//  WalletDetailMoreBottomSheetViewController.swift
//  Ballet
//
//  Created by Koray Koska on 24.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit

class WalletDetailMoreBottomSheetViewController: UIViewController {

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissClicked)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    @objc private func dismissClicked() {
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
