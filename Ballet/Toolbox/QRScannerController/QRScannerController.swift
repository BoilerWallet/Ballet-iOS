//
//  QRScannerController.swift
//  Ballet
//
//  Created by Koray Koska on 01.09.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import AudioToolbox
import Material
import Cartography

class QRScannerController: UIViewController {

    // MARK: - Properties

    var completion: ((_ str: String) -> Void)?

    private var scanner: QRCodeScanner?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        scanner = QRCodeScanner(on: view)
        if !(scanner?.boot() ?? false) {
            let controller = UIAlertController(
                title: "Scanning not supported",
                message: "Your device does not support scanning QR codes. Please use a device with a camera.",
                preferredStyle: .alert
            )
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            let time = DispatchTime.now().uptimeNanoseconds + 10000000
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: time)) { [weak self] in
                self?.present(controller, animated: true)
            }

            scanner = nil
        }
        scanner?.completion = { str in
            // Vibration
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            // Dismiss
            self.dismiss(animated: true, completion: nil)

            // Completion
            self.completion?(str)
        }

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _ = scanner?.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        scanner?.stop()
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = UIColor.black

        let dismissButton = IconButton(image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), tintColor: Colors.lightPrimaryTextColor)
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)

        view.addSubview(dismissButton)

        constrain(view, dismissButton) { container, button in
            button.width == 24
            button.height == 24
            button.right == container.right - 16
            button.top == container.top + 16
        }
    }

    // MARK: - View conveniences

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Actions

    @objc private func dismissClicked() {
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
