//
//  SelectAccountCollectionViewController.swift
//  Ballet
//
//  Created by Koray Koska on 01.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import RealmSwift
import Material
import Cartography

private let reuseIdentifier = "selectAccountCell"

class SelectAccountCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    private var selectLabel: UILabel!

    var completion: ((_ selectedAccount: EncryptedAccount) -> Void)?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        setupUI()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        selectLabel = UILabel()
        view.addSubview(selectLabel)

        constrain(view, selectLabel) { container, label in
            label.height >= 24
            label.left == container.left + 16
            label.right == container.right - 16
            label.top == container.top + 8
        }

        selectLabel.setupSubTitleLabelWithSize(size: 22)
        selectLabel.textAlignment = .center
        selectLabel.numberOfLines = 0
        selectLabel.text = "Select Your Account"

        // Motion
        isMotionEnabled = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LoggedInUser.shared.encryptedAccounts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectAccountCollectionViewCell

        let accounts = LoggedInUser.shared.encryptedAccounts
        if accounts.count > indexPath.row {
            let account = accounts[indexPath.row]

            cell.onClick = { [weak self] in
                self?.completion?(account)
                self?.dismiss(animated: true, completion: nil)
            }

            cell.setup(with: account)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

extension SelectAccountCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        if Screen.width < Screen.height {
            width = Screen.width / 2 - 32
        } else {
            width = Screen.width / 4 - 16
        }
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        selectLabel.setNeedsLayout()
        selectLabel.layoutIfNeeded()
        return UIEdgeInsets(top: selectLabel.bounds.height + 8, left: 0, bottom: 0, right: 0)
    }
}
