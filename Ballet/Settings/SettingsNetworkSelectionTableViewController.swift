//
//  SettingsNetworkSelectionTableViewController.swift
//  Ballet
//
//  Created by Koray Koska on 19.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import RealmSwift
import PromiseKit
import MaterialComponents.MaterialDialogs

class SettingsNetworkSelectionTableViewController: UITableViewController {

    // MARK: - Properties

    private static let defaultNetworkCellIdentifier = "networkSelectionCell"

    private var rows: Results<RPCUrl>?

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
    }

    private func fillUI() {
        navigationItem.titleLabel.text = "Select Network"

        firstly {
            unwrap(try? Realm())
        }.done { realm in
            self.rows = realm.objects(RPCUrl.self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).defaultNetworkCellIdentifier, for: indexPath) as! SettingsNetworkSelectionCell

        if let rows = rows {
            cell.setup(for: rows[indexPath.row])
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        firstly {
            unwrap(try? Realm())
        }.done { realm in
            try realm.write {
                for u in realm.objects(RPCUrl.self) {
                    u.isActive = false
                }
                self.rows?[indexPath.row].isActive = true
            }
            self.tableView.reloadData()
        }.catch { error in
            Dialog().title("Something went wrong").details(error.localizedDescription).positive("OK", handler: nil).show(self)
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
