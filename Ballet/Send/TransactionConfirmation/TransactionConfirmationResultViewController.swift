//
//  TransactionConfirmationResultViewController.swift
//  Ballet
//
//  Created by Koray Koska on 03.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3

class TransactionConfirmationResultViewController: UIViewController {

    // MARK: - Properties

    var rpcUrl: RPCUrl?
    var txHashData: EthereumData?

    @IBOutlet weak var txInfo: UILabel!
    @IBOutlet weak var txHashInfo: UILabel!
    @IBOutlet weak var txHash: UILabel!

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
        txHashInfo.setupSubTitleLabel()
        txHash.setupSubTitleLabel()

        txInfo.text = "Your transaction was sent successfully. It should get included into the blockchain soon."
        txHashInfo.text = "Your transaction hash is the following"
        txHash.text = txHashData?.hex()
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
