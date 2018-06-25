//
//  SettingsTokenTrackerTableView.swift
//  Ballet
//
//  Created by Koray Koska on 24.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3
import RealmSwift

class SettingsTokenTrackerTableView: UITableView {

    // MARK: - Properties

    var deleteRequested: ((_ token: ERC20TrackedToken) -> Void)?

    private static let defaultTokenCellIdentifier = "tokenTrackerCell"

    private var rows: Results<ERC20TrackedToken>?

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        delegate = self
        dataSource = self

        rowHeight = 88

        setupUI()
        fillUI()
    }

    // MARK: - UI setup

    private func setupUI() {
    }

    private func fillUI() {
        firstly {
            unwrap(try? Realm())
        }.done { realm in
            self.rows = realm.objects(ERC20TrackedToken.self).filter("rpcUrlID == '\(RPC.activeUrl.rpcUrlID)'")
            self.reloadData()
        }.catch { error in
            // TODO: Handle error
            print(error)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

extension SettingsTokenTrackerTableView: UITableViewDelegate {

}

// MARK: - Table view data source

extension SettingsTokenTrackerTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).defaultTokenCellIdentifier, for: indexPath) as! SettingsTokenTrackerTableViewCell

        if let row = rows?[indexPath.row], let address = try? EthereumAddress(hex: row.addressString, eip55: false) {
            cell.setup(name: row.name, address: address)
        }

        return cell
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let rows = rows {
                deleteRequested?(rows[indexPath.row])
            }
        }
    }
}
