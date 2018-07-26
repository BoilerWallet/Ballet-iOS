//
//  SettingsOpenSourceLibrariesViewController.swift
//  Ballet
//
//  Created by Koray Koska on 26.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import Down
import PromiseKit
import Curry
import Runes
import Cartography

class SettingsOpenSourceLibrariesViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var loadingView: LoadingView!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        navigationItem.titleLabel.textColor = Colors.lightPrimaryTextColor
        navigationItem.backButton.tintColor = Colors.lightPrimaryTextColor
        navigationItem.titleLabel.text = "Open Source Libraries"

        loadingView.startLoading()

        firstly {
            SettingsMarkdownAPI.getOpenSourceLibraries()
        }.done { data in
            guard let dataString = String(data: data, encoding: .utf8) else {
                return
            }

            let downView = try DownView(frame: self.view.bounds, markdownString: dataString)

            self.view.addSubview(downView)

            constrain(self.view, downView) { container, downView in
                downView.left == container.left
                downView.right == container.right
                downView.top == container.top
                downView.bottom == container.bottom
            }
        }.catch { error in
            print(error)
        }.finally {
            self.loadingView.stopLoading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
