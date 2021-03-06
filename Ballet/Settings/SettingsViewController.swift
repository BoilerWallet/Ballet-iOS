//
//  SettingsViewController.swift
//  Ballet
//
//  Created by Ben Koska on 12/21/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import SafariServices
import Material
import RealmSwift
import Runes

class SettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var generalTitle: UILabel!

    @IBOutlet weak var selectNetworkElement: SettingsElement!
    @IBOutlet weak var trackedTokensElement: SettingsElement!

    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var changePasswordElement: SettingsElement!

    @IBOutlet weak var aboutTitle: UILabel!
    @IBOutlet weak var termsAndConditionsElement: SettingsElement!
    @IBOutlet weak var privacyPolicyElement: SettingsElement!
    @IBOutlet weak var openSourceLibrariesElement: SettingsElement!

    @IBOutlet weak var moreTitle: UILabel!
    @IBOutlet weak var donateElement: SettingsElement!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fill UI on view did appear as they can change
        fillUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = Colors.background

        setupToolbar()

        setupGeneral()
        setupAccount()
        setupAbout()
        setupMore()
    }

    private func setupToolbar() {
        navigationItem.titleLabel.text = "Settings"
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
    }

    private func setupGeneral() {
        generalTitle.setupTitleLabel()
        generalTitle.textColor = Colors.primaryColor

        selectNetworkElement.onClick = selectNetworkClicked
        trackedTokensElement.onClick = trackedTokensClicked
    }

    private func setupAccount() {
        accountTitle.setupTitleLabel()
        accountTitle.textColor = Colors.primaryColor

        changePasswordElement.onClick = changePasswordClicked
    }

    private func setupAbout() {
        aboutTitle.setupTitleLabel()
        aboutTitle.textColor = Colors.primaryColor

        openSourceLibrariesElement.onClick = openSourceLibrariesClicked
    }

    private func setupMore() {
        moreTitle.setupTitleLabel()
        moreTitle.textColor = Colors.primaryColor
    }

    private func fillUI() {
        fillGeneral()
        fillAccount()
        fillAbout()
        fillMore()
    }

    private func fillGeneral() {
        selectNetworkElement.subtitleText = RPC.activeUrl.name

        let rpcUrlId = RPC.activeUrl.rpcUrlID
        trackedTokensElement.subtitleText = String.init <^> (try? Realm().objects(ERC20TrackedToken.self).filter("rpcUrlID == '\(rpcUrlId)'").count)
    }

    private func fillAccount() {
    }

    private func fillAbout() {
    }

    private func fillMore() {
    }

    // MARK: - Actions

    private func selectNetworkClicked() {
        performSegue(withIdentifier: "selectNetworkSegue", sender: self)
    }

    private func trackedTokensClicked() {
        performSegue(withIdentifier: "tokenTrackerSegue", sender: self)
    }

    private func changePasswordClicked() {
        performSegue(withIdentifier: "changePasswordSegue", sender: self)
    }

    private func openSourceLibrariesClicked() {
        performSegue(withIdentifier: "openSourceLibrariesSegue", sender: self)
    }
}
