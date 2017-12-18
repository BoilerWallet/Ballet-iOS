//
//  LoginViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/17/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import LocalAuthentication
import Material

class LoginViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var biometryButton: IconButton!

    @IBOutlet weak var passwordField: TextField!

    @IBOutlet weak var loginButton: FlatButton!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI setup

    private func setupUI() {
        self.view.backgroundColor = Colors.primaryColorWAlpha(alpha: 0.8)

        // Login button
        loginButton.backgroundColor = Colors.secondaryColor
        loginButton.titleColor = Colors.white

        // Password field
        passwordField.returnKeyType = .done
    }

    // MARK: - Biometry

    private func checkBiometry(context: LAContext) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        // unlock wallet
                        let story = UIStoryboard(name: "Wallet", bundle: nil)
                        let viewcontroller = story.instantiateInitialViewController()
                        self?.present(viewcontroller!, animated: true, completion: nil)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified! Please enter use password authentication.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)

                        self?.biometryButton.isEnabled = true
                        self?.biometryButton.imageView?.image = UIImage(named: "ic_fingerprint")?.withRenderingMode(.alwaysTemplate)
                        self?.biometryButton.imageView?.tintColor = Color.white
                        if context.biometryType == .faceID {
                            self?.biometryButton.imageView?.image = UIImage(named: "faceid")?.withRenderingMode(.alwaysTemplate)
                        }
                    }
                }
            }
        } else {
            // no biometry option availible (not compatible with Touch ID and/or Face ID)
            // password authentication
        }
    }

    // MARK: - Actions

    @IBAction func biometryButtonClicked(_ sender: Any) {
        let context = LAContext()
        checkBiometry(context: context)
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        if passwordField.text == "123" {
            let story = UIStoryboard(name: "Wallet", bundle: nil)
            let viewcontroller = story.instantiateInitialViewController()
            self.present(viewcontroller!, animated: true, completion: nil)
        }
    }
}
