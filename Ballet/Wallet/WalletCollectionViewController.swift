//
//  WalletCollectionViewController.swift
//  Ballet
//
//  Created by Koray Koska on 23.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Material
import StoreKit
import SafariServices
import Cartography
import Web3
import RealmSwift
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialDialogs

private let reuseIdentifier = "walletCell"

class WalletCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private var addAccountButton: MDCFloatingButton!

    private var accounts: Results<Account>?

    private var refreshControl: UIRefreshControl!

    private var lastKnownRPCUrl: RPCUrl?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        setupUI()

        getAccounts()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let lastKnown = lastKnownRPCUrl, !RPCUrl.rawEquals(lastKnown, RPC.activeUrl) {
            reloadCollection()
        }
    }

    // MARK: - UI setup

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

        setupToolbar()

        setupAddAccountButton()

        // Motion
        isMotionEnabled = true
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Ballet"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor

        let rate = IconButton(image: Icon.favoriteBorder, tintColor: Colors.lightPrimaryTextColor)
        rate.addTarget(self, action: #selector(rateClicked), for: .touchUpInside)

        navigationItem.rightViews = [rate]

        navigationItem.leftViews = [createNetworkColorButton()]
    }

    private func setupAddAccountButton() {
        addAccountButton = MDCFloatingButton()
        view.addSubview(addAccountButton)

        constrain(view, addAccountButton) { view, button in
            button.right == view.right - 16
            button.bottom == view.bottom - 16
            button.width == 56
            button.height == 56
        }

        addAccountButton.setBackgroundColor(Colors.accentColor)

        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysTemplate)
        addAccountButton.setImage(image, for: .normal)
        addAccountButton.setImage(image, for: .selected)

        addAccountButton.tintColor = Colors.white

        addAccountButton.addTarget(self, action: #selector(addAccountButtonClicked), for: .touchUpInside)
    }

    // MARK: - Helper functions

    private func getAccounts() {
        lastKnownRPCUrl = RPC.activeUrl

        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            return
        }
        accounts = realm.objects(Account.self)
    }

    private func saveNewAccount(privateKey: EthereumPrivateKey, name: String) {
        let account = Account()
        account.name = name
        account.privateKey = privateKey.hex()
        account.encrypted = false
        account.salt = nil

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(account)
            }
        } catch {
            let details = "Something went wrong while saving your new account. Please try again or file an issue on Github."
            Dialog().details(details).positive("OK", handler: nil).show(self)
        }
    }

    // MARK: - Actions

    @objc private func reloadCollection() {
        navigationItem.leftViews = [createNetworkColorButton()]
        getAccounts()
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }

    @objc private func addAccountButtonClicked() {
        guard let controller = UIStoryboard(name: "AddAccount", bundle: nil).instantiateInitialViewController() as? AddAccountViewController else {
            return
        }
        controller.completion = { [weak self] selected, name in
            self?.saveNewAccount(privateKey: selected, name: name)
            self?.collectionView?.reloadData()
        }

        PopUpController.instantiate(from: self, with: controller)
    }

    @objc private func rateClicked() {
        if UserDefaults.standard.bool(forKey: "reviewed") {
            donate()
        } else {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: "reviewed")
            } else {
                donate()
            }
        }
    }

    @objc private func networkColorClicked() {
        let active = RPC.activeUrl

        Dialog.selectedNetwork(for: active).show(self)
    }

    private func donate() {
        let path = "https://ballet.boilertalk.com/donate"
        guard let url = NSURL(string: path) else { return }

        if #available(iOS 9.0, *) {
            let controller: SFSafariViewController = SFSafariViewController(url: url as URL)
            self.present(controller, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }

    // MARK: - Helpers

    func createNetworkColorButton() -> IconButton {
        let networkColor = IconButton()
        let image = UIImage.from(color: RPC.activeUrl.networkColor, width: 24, height: 24)?.af_imageRoundedIntoCircle()
        networkColor.setImage(image, for: .normal)
        networkColor.setImage(image, for: .highlighted)
        networkColor.addTarget(self, action: #selector(networkColorClicked), for: .touchUpInside)

        return networkColor
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
        return accounts?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WalletCollectionViewCell

        if let accounts = accounts, accounts.count > indexPath.row {
            cell.setup(with: accounts[indexPath.row]) { [weak self] account in
                self?.performSegue(withIdentifier: "WalletDetail", sender: cell)
            }
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? WalletCollectionViewCell, segue.identifier == "WalletDetail" {
            if let controller = segue.destination as? WalletDetailViewController, let account = cell.currentAccount {
                controller.account = account

                let uuid = UUID().uuidString
                let containerId = "WalletDetailContainer" + uuid
                let blockiesId = "WalletDetailBlockies" + uuid
                let nameId = "WalletDetailsName" + uuid
                let balanceId = "WalletDetailsBalance" + uuid
                let addressId = "WalletDetailsAddress" + uuid

                cell.motionIdentifier = containerId
                cell.shapePreset = .square

                cell.blockiesImage.motionIdentifier = blockiesId
                cell.blockiesImage.shapePreset = .circle

                // cell.nameLabel.motionIdentifier = nameId
                // cell.nameLabel.shapePreset = .square

                cell.balanceLabel.motionIdentifier = balanceId
                cell.balanceLabel.shapePreset = .square

                cell.addressLabel.motionIdentifier = addressId
                cell.addressLabel.shapePreset = .square

                controller.motionIdentifiers = .init(container: containerId, blockies: blockiesId, name: nameId, balance: balanceId, address: addressId)
            }
        }
    }

    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let accounts = accounts, accounts.count > indexPath.row {
        }
    }*/

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

extension WalletCollectionViewController: UICollectionViewDelegateFlowLayout {

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
