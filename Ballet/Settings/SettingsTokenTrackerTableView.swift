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
import Curry
import Runes

class SettingsTokenTrackerTableView: UITableView {

    // MARK: - Properties

    /// Set to get a callback if a deletion for a token was requested.
    var deleteRequested: ((_ token: ERC20TrackedToken) -> Void)?

    /// Set to get a callback if a token was selected. nil always means ETH was selected.
    var tokenSelected: ((_ token: ERC20TrackedToken?) -> Void)?

    /// Set to true to show ETH as the first "tracked token"
    var showEth = false

    private static let defaultTokenCellIdentifier = "tokenTrackerCell"
    private static let defaultETHTokenCellIdentifier = "tokenTrackerETHCell"

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tokenSelected, let rows = rows {
            let cellIndex = showEth ? indexPath.row - 1 : indexPath.row
            if cellIndex >= 0 {
                tokenSelected?(rows[cellIndex])
            } else {
                tokenSelected?(nil)
            }
        }
    }
}

// MARK: - Table view data source

extension SettingsTokenTrackerTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showEth {
            // To prevent insta brain cancer just believe me that the following line returns
            // either rows.count + 1 if rows is not nil or 1 otherwise.
            return (curry(+) <^> rows?.count <*> 1) ?? 1
        } else {
            return rows?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showEth && indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: type(of: self).defaultETHTokenCellIdentifier, for: indexPath) as! SettingsTokenTrackerETHTableViewCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).defaultTokenCellIdentifier, for: indexPath) as! SettingsTokenTrackerTableViewCell

        let cellIndex = showEth ? indexPath.row - 1 : indexPath.row
        if let row = rows?[cellIndex], let address = try? EthereumAddress(hex: row.addressString, eip55: false) {
            cell.setup(name: row.name, address: address)
        }

        return cell
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let _ = deleteRequested, editingStyle == .delete {
            if let rows = rows {
                let cellIndex = showEth ? indexPath.row - 1 : indexPath.row
                if cellIndex >= 0 {
                    deleteRequested?(rows[cellIndex])
                }
            }
        }
    }
}
