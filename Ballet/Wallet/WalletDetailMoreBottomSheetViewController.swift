//
//  WalletDetailMoreBottomSheetViewController.swift
//  Ballet
//
//  Created by Koray Koska on 24.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit

class WalletDetailMoreBottomSheetViewController: UIViewController {

    // MARK: - Properties

    var deleteClicked: (() -> Void)?
    var editNameClicked: (() -> Void)?
    var shareClicked: (() -> Void)?

    @IBOutlet weak var deleteElement: BottomSheetElement!
    @IBOutlet weak var editNameElement: BottomSheetElement!
    @IBOutlet weak var shareElement: BottomSheetElement!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissClicked)))

        deleteElement.onClick = deleteViewClicked
        editNameElement.onClick = editNameViewClicked
        shareElement.onClick = shareViewClicked
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    @objc private func dismissClicked() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func deleteViewClicked() {
        dismissClicked()
        deleteClicked?()
    }

    @objc private func editNameViewClicked() {
        dismissClicked()
        editNameClicked?()
    }

    @objc private func shareViewClicked() {
        dismissClicked()
        shareClicked?()
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
