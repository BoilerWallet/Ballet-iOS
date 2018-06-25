//
//  SettingsTokenTrackerViewController.swift
//  Ballet
//
//  Created by Koray Koska on 25.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialButtons
import Cartography
import RealmSwift

class SettingsTokenTrackerViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var networkCard: MDCCard!
    @IBOutlet weak var networkColor: UIView!
    @IBOutlet weak var networkLabel: UILabel!

    @IBOutlet weak var tokenTrackerTableView: SettingsTokenTrackerTableView!

    private var trackButton: MDCFloatingButton!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

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

        networkCard.cornerRadius = 0
        networkCard.addTarget(self, action: #selector(networkCardClicked), for: .touchUpInside)
        networkColor.layer.cornerRadius = networkColor.bounds.width / 2
        networkColor.layer.masksToBounds = true
        networkColor.isUserInteractionEnabled = false
        networkLabel.setupSubTitleLabel()

        tokenTrackerTableView.deleteRequested = { [weak self] token in
            self?.deleteTrackedToken(token: token)
        }

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

        let url = RPC.activeUrl
        networkColor.backgroundColor = url.networkColor
        networkLabel.text = url.name
    }

    // MARK: - Actions

    @objc private func trackButtonClicked() {
        guard let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "TrackNewTokenController") as? SettingsTrackNewTokenViewController else {
            return
        }
        controller.completion = { [weak self] token in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(token)
                }
                self?.tokenTrackerTableView.reloadData()
            } catch {
                if let s = self {
                    let details = "Something went wrong while saving your tracked token. Please try again or file an issue on Github."
                    Dialog().details(details).positive("OK", handler: nil).show(s)
                }
            }
        }

        PopUpController.instantiate(from: self, with: controller)
    }

    @objc private func networkCardClicked() {
        let url = RPC.activeUrl

        Dialog.selectedNetwork(for: url).show(self)
    }

    // MARK: - Helpers

    private func deleteTrackedToken(token: ERC20TrackedToken) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(token)
            }
            tokenTrackerTableView.reloadData()
        } catch {
            let details = "Something went wrong while deleting your tracked token. Please try again or file an issue on Github."
            Dialog().details(details).positive("OK", handler: nil).show(self)
        }
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
