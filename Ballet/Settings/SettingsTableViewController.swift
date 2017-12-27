git//
//  SettingsTableViewController.swift
//  Ballet
//
//  Created by Ben Koska on 12/21/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import SafariServices
import Material

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties

    @IBOutlet weak var firstLineImageView: UIImageView!

    @IBOutlet weak var secondLineImageView: UIImageView!

    @IBOutlet weak var thirdLineImageView: UIImageView!

    @IBOutlet weak var fourthLineImageView: UIImageView!

    @IBOutlet weak var fifthLineImageView: UIImageView!

    var urls = ["https://svizzr.com/terms.html", "https://svizzr.com/privacy.html", "https://svizzr.com/opensource.html", "https://svizzr.com/imprint.html", "https://boilertalk.com/donate"]

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {

        let bg = UIView()
        bg.backgroundColor = Colors.background
        tableView.tableFooterView = bg

        tableView.backgroundColor = Colors.background
        view.backgroundColor = Colors.background

        let array = [firstLineImageView, secondLineImageView, thirdLineImageView, fourthLineImageView, fifthLineImageView]

        for i in array {
            i?.image = UIImage(named: "ic_keyboard_arrow_right")?.withRenderingMode(.alwaysTemplate)
            i?.tintColor = Color.black.withAlphaComponent(0.54)
        }

        let image = UIImage(named: "ic_clear")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.addTarget(self, action: #selector(buttonDismissClicked), for: UIControlEvents.touchUpInside)
        navigationItem.leftViews = [button]
        navigationItem.rightViews = [UIButton()]

        navigationItem.title = "Information"

        setupToolbar()
    }

    // MARK: - Actions

    @objc func buttonDismissClicked() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = urls[indexPath.row]
        guard let url = NSURL(string: path) else { return }

        if #available(iOS 9.0, *) {
            let controller: SFSafariViewController = SFSafariViewController(url: url as URL)
            self.present(controller, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Settings"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
    }
}
