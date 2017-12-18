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

    @IBOutlet weak var biometryButton: IconButton!
    
    @IBOutlet weak var passwordField: TextField!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if passwordField.text == "123" {
            let story = UIStoryboard(name: "Wallet", bundle: nil)
            let viewcontroller = story.instantiateInitialViewController()
            self.present(viewcontroller!, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ConstantHolder.primaryColorWAlpha(alpha: 0.8)
        
        let context = LAContext()
        var error: NSError?
        
        biometryButton.isHidden = true
        biometryButton.isEnabled = false
        
        loginButton.backgroundColor = ConstantHolder.secondaryColor
        loginButton.titleColor = ConstantHolder.white
        
        checkBiometry(context: context, error: error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func biometryButtonClicked(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        checkBiometry(context: context, error: error)
    }
    @IBOutlet weak var loginButton: FlatButton!
    
    func checkBiometry(context: LAContext, error: NSError?) {
        var error = error
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        // unlock wallet
                        let story = UIStoryboard(name: "Wallet", bundle: nil)
                        let viewcontroller = story.instantiateInitialViewController()
                        self.present(viewcontroller!, animated: true, completion: nil)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified! Please enter use password authentication.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        
                        self.biometryButton.isEnabled = true
                        self.biometryButton.imageView?.image = UIImage(named: "ic_fingerprint")?.withRenderingMode(.alwaysTemplate)
                        self.biometryButton.imageView?.tintColor = Color.white
                        if context.biometryType == .faceID {
                            self.biometryButton.imageView?.image = UIImage(named: "faceid")?.withRenderingMode(.alwaysTemplate)
                        }
                    }
                }
            }
        } else {
            // no biometry option availible (not compatible with Touch ID and/or Face ID)
            // password authentication
        }
    }
}
