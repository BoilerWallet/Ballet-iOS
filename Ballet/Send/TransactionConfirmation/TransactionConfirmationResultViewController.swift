//
//  TransactionConfirmationResultViewController.swift
//  Ballet
//
//  Created by Koray Koska on 03.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3
import MaterialComponents.MaterialButtons

class TransactionConfirmationResultViewController: UIViewController {

    // MARK: - Properties

    var rpcUrl: RPCUrl?
    var txHashData: EthereumData?

    @IBOutlet weak var txInfo: UILabel!
    @IBOutlet weak var txHashInfo: UILabel!
    @IBOutlet weak var txHash: UILabel!

    @IBOutlet weak var showOnEtherscan: MDCFlatButton!
    @IBOutlet weak var done: MDCRaisedButton!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        guard txHashData != nil && rpcUrl != nil else {
            dismiss(animated: true, completion: nil)
            return
        }

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        txInfo.setupSubTitleLabelWithSize(size: 22)
        txInfo.textAlignment = .center

        txHashInfo.setupSubTitleLabel()

        txHash.setupSubTitleLabel()

        showOnEtherscan.setTitleColor(Colors.accentColor, for: .normal)
        showOnEtherscan.setTitle("Show on ETherscan", for: .normal)
        showOnEtherscan.addTarget(self, action: #selector(showOnEtherscanClicked), for: .touchUpInside)
        if rpcUrl?.etherscanBaseUrl == nil {
            showOnEtherscan.isHidden = true
        }

        done.setTitle("Done", for: .normal)
        done.setTitleColor(Colors.lightPrimaryTextColor, for: .normal)
        done.setBackgroundColor(Colors.accentColor)
        done.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)

        txInfo.text = "Your transaction was sent successfully"
        txHashInfo.text = "It should get included into the blockchain soon. Your transaction hash is the following"
        txHash.text = txHashData?.hex()
    }

    // MARK: - Actions

    @objc private func showOnEtherscanClicked() {
        guard let u = rpcUrl?.etherscanBaseUrl, let tx = txHashData, let url = URL(string: "\(u)/tx/\(tx.hex())") else {
            return
        }
        UIApplication.shared.openURL(url)
    }

    @objc private func doneClicked() {
        dismiss(animated: true, completion: nil)
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
