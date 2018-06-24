//
//  SettingsTokenTrackerTableViewController.swift
//  Ballet
//
//  Created by Koray Koska on 24.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3
import RealmSwift
import Cartography
import MaterialComponents.MaterialButtons

class SettingsTokenTrackerTableViewController: UITableViewController {

    // MARK: - Properties

    private static let defaultTokenCellIdentifier = "tokenTrackerCell"

    private var rows: Results<ERC20TrackedToken>?

    private var trackButton: MDCFloatingButton!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        tableView.rowHeight = 88

        setupUI()
        fillUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = Colors.background
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor

        setupTrackButton()
    }

    private func setupTrackButton() {
        trackButton = MDCFloatingButton()
        view.addSubview(trackButton)

        constrain(view, trackButton) { view, button in
            button.right == view.right - 16
            button.bottom == view.bottom - 16
            button.width == 56
            button.height == 56
        }

        trackButton.setBackgroundColor(Colors.accentColor)

        let image = UIImage(named: "ic_add")?.withRenderingMode(.alwaysTemplate)
        trackButton.setImage(image, for: .normal)
        trackButton.setImage(image, for: .selected)

        trackButton.tintColor = Colors.white

        trackButton.addTarget(self, action: #selector(trackButtonClicked), for: .touchUpInside)
    }

    private func fillUI() {
        navigationItem.titleLabel.text = "Tracked ERC20 Tokens"

        firstly {
            unwrap(try? Realm())
        }.done { realm in
            self.rows = realm.objects(ERC20TrackedToken.self)
            self.tableView.reloadData()
        }.catch { error in
            // TODO: Handle error
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).defaultTokenCellIdentifier, for: indexPath) as! SettingsTokenTrackerTableViewCell

        if let row = rows?[indexPath.row], let address = try? EthereumAddress(hex: row.addressString, eip55: false) {
            cell.setup(name: row.name, symbol: row.symbol, address: address)
        }

        return cell
    }

    // MARK: - Actions

    @objc private func trackButtonClicked() {
        guard let controller = UIStoryboard(name: "AddAccount", bundle: nil).instantiateInitialViewController() as? AddAccountViewController else {
            return
        }
        controller.completion = { [weak self] selected, name in
            self?.saveNewAccount(privateKey: selected, name: name)
            self?.collectionView?.reloadData()
        }

        PopUpController.instantiate(from: self, with: controller)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
