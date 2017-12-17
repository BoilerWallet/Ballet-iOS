//
//  LoginViewController.swift
//  Ballet
//
//  Created by Ben Koksa on 12/17/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        // unlock wallet
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified! Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Try Again", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry option availible (not compatible with Touch ID and/or Face ID)
            // password authentication
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
