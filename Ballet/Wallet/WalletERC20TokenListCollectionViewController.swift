//
//  WalletERC20TokenListCollectionViewController.swift
//  Ballet
//
//  Created by Koray Koska on 25.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import RealmSwift
import Web3

private let reuseIdentifier = "erc20TokenListCell"

class WalletERC20TokenListCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    var account: EncryptedAccount!

    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private var rows: Results<ERC20TrackedToken>?

    private var refreshControl: UIRefreshControl!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        guard account != nil else {
            dismiss(animated: true, completion: nil)
            return
        }

        setupUI()
        fillUI()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = Colors.background
        collectionView?.backgroundColor = Colors.background

        // Hide vertical scrolling indicator
        collectionView?.showsVerticalScrollIndicator = false

        // Always allow reloading/scrolling
        collectionView?.alwaysBounceVertical = true

        // Setup reload button
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadCollection), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl)

        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor
    }

    private func fillUI() {
        navigationItem.titleLabel.text = "\(account.account.name)"

        firstly {
            unwrap(try? Realm())
        }.done { realm in
            self.rows = realm.objects(ERC20TrackedToken.self).filter("rpcUrlID == '\(RPC.activeUrl.rpcUrlID)'")
            self.collectionView?.reloadData()
        }.catch { error in
            // TODO: - Handle error
            print(error)
        }
    }

    // MARK: - Actions

    @objc private func reloadCollection() {
        collectionView?.reloadData()
        refreshControl.endRefreshing()
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
        return rows?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WalletERC20TokenListCollectionViewCell

        if let element = rows?[indexPath.row] {
            try cell.setup(with: element, for: account.address)
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

extension WalletERC20TokenListCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        if Screen.width < Screen.height {
            width = Screen.width
        } else {
            width = Screen.width / 2
        }
        let height: CGFloat = 88 + 32
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
