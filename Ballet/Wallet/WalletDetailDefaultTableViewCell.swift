//
//  WalletDetailDefaultTableViewCell.swift
//  Ballet
//
//  Created by Koray Koska on 25.05.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Web3
import Material
import BigInt
import MarqueeLabel
import DateToolsSwift

class WalletDetailDefaultTableViewCell: TableViewCell {

    // MARK: - Properties

    @IBOutlet weak var inOutArrow: UIImageView!
    @IBOutlet weak var fromToAddress: MarqueeLabel!
    @IBOutlet weak var value: MarqueeLabel!
    @IBOutlet weak var age: MarqueeLabel!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - UI setup

    private func setupUI() {
        fromToAddress.setupSubTitleLabel()

        value.setupSubTitleLabel()
        value.textAlignment = .center

        age.setupSubTitleLabel()
        age.textAlignment = .center
    }

    // MARK: - Cell setup

    func setup(for address: EthereumAddress, with transaction: EtherscanTransaction) {
        let fromIsSelf = transaction.from == address
        let toIsSelf = transaction.to == address
        if fromIsSelf && toIsSelf {
            // Self tx
            inOutArrow.image = UIImage(named: "baseline_loop_black_24pt")?.withRenderingMode(.alwaysTemplate)
            inOutArrow.tintColor = Color.blue.base

            // self -> self
            fromToAddress.text = "self -> self"
        } else if fromIsSelf {
            // Out tx
            inOutArrow.image = UIImage(named: "baseline_arrow_upward_black_24pt")?.withRenderingMode(.alwaysTemplate)
            inOutArrow.tintColor = Color.red.base

            // Only to is relevant
            fromToAddress.text = "self -> \(transaction.to.hex(eip55: true))"
        } else {
            // In tx
            inOutArrow.image = UIImage(named: "baseline_arrow_downward_black_24pt")?.withRenderingMode(.alwaysTemplate)
            inOutArrow.tintColor = Color.green.base

            // Only from is relevant
            fromToAddress.text = "\(transaction.from.hex(eip55: true)) -> self"
        }

        var valueStr = String(transaction.value.intValue, radix: 10).weiToEthStr()
        if valueStr.count > 6 {
            let startIndex = valueStr.startIndex
            let endIndex = valueStr.index(valueStr.startIndex, offsetBy: 6)
            valueStr = "~ \(String(valueStr[startIndex..<endIndex]))"
        }
        value.text = "\(valueStr) ETH"

        if let timeStamp = Int(String(transaction.timeStamp.intValue, radix: 10)) {
            let date = Date(timeIntervalSince1970: Double(timeStamp))
            age.text = date.shortTimeAgoSinceNow
        } else {
            age.text = "???"
        }
    }
}
